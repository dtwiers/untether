defmodule Untether.Communicator.Listener do
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(opts) do
    config = opts[:config]
    instance_id = opts[:instance_id]
    socket_path = config.communication.compositor_socket
    Logger.debug("Starting listener on #{socket_path}")
    Logger.debug("Starting listener; instance_id=#{instance_id}, socket_path=#{socket_path}")
    with {:ok, listener} <- open_socket(socket_path) do
      Task.start(fn -> accept_new_connections(listener, instance_id) end)
    end
  end

  defp accept_new_connections(listener, instance_id) do
    with {:ok, socket} <- :gen_tcp.accept(listener) do
      Logger.debug("Accepted connection from #{inspect(socket)}")
      case Untether.Communicator.ClientSupervisor.start_child(socket, instance_id) do
        {:ok, pid} -> :gen_tcp.controlling_process(socket, pid)
        {:ok, pid, _} -> :gen_tcp.controlling_process(socket, pid)
        :ignore -> :ignore
        {:error, {:already_started, _pid}} -> :already_started
      end

      accept_new_connections(listener, instance_id)
    end
  end

  defp open_socket(socket_path) do
    if File.exists?(socket_path), do: File.rm!(socket_path)

    :gen_tcp.listen(0, [
      :binary,
      packet: :raw,
      active: false,
      mode: :binary,
      ifaddr: {:local, socket_path},
      reuseaddr: true
    ])
  end
end
