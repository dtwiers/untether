defmodule Untether.Communicator.Client do
  use GenServer
  require Logger

  alias Untether.Communicator.Router

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: args[:name])
  end

  def child_spec(opts) do
    %{
      id: {:client, opts[:id]},
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :transient,
      shutdown: 500
    }
  end

  @impl true
  def init(opts) do
    socket = opts[:socket]
    instance_id = opts[:instance_id]
    id = opts[:id]
    name = {:by_id, id}
    Logger.debug("opts: #{inspect(opts)}")
    Logger.debug("Starting client on #{inspect(socket)} with id #{id}")
    :inet.setopts(socket, active: true)
    state = %{socket: socket, codec: nil, role: nil, id: id, name: name, instance_id: instance_id}
    Logger.debug("state of #{inspect(self())}: #{inspect(state)}")
    {:ok, state}
  end

  @impl true
  def terminate(reason, state) do
    Logger.debug("Terminating client on #{inspect(state.socket)} with reason #{inspect(reason)}")
    # :gen_tcp.close(state.socket)
  end

  @impl true
  def handle_info({:tcp, _socket, data}, state) do
    Logger.debug("Received data: #{inspect(data)}")

    {:ok, data} =
      decode_data(data, state)

    actions =
      data
      |> Router.route(state.name)

    handle_identify(actions, state)
  end

  def handle_info({:tcp_closed, _socket}, state) do
    Logger.debug("Connection closed")
    {:stop, :normal, state}
  end

  defp handle_identify(
         actions,
         %{name: {:by_id, _}, instance_id: instance_id} = state
       ) do
    case Enum.find(actions, &(&1.type == :identify)) do
      %{role: role} ->
        Logger.debug("Identified as #{role}")

        case Untether.Registry.rename(:client, instance_id, {:by_id, state.id}, :compositor) do
          {:ok, _pid} ->
            Logger.debug("Registered as #{role} - success")
            {:noreply, %{state | role: role, name: role}}

          {:error, {:already_registered, _pid}} ->
            Logger.debug("Registered as #{role} - duplicate")
            {:stop, :shutdown, state}
        end

      _ ->
        {:noreply, state}
    end
  end

  defp handle_identify(_, state), do: {:noreply, state}

  defp decode_data(data, _state) do
    JSON.decode(data)
  end
end
