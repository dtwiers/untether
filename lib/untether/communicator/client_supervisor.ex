defmodule Untether.Communicator.ClientSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(opts) do
    instance_id = opts[:instance_id]
    Logger.debug("Starting client supervisor; instance_id=#{instance_id}")
    Logger.debug("Client Supervisor Name: #{inspect(Untether.Registry.generate_name(__MODULE__, instance_id))}")
    DynamicSupervisor.start_link(__MODULE__, :ok, name: Untether.Registry.generate_name(__MODULE__, instance_id))
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(socket, instance_id) do
    unique_id = System.unique_integer()
    name = Untether.Registry.generate_name(:client, instance_id, {:by_id, unique_id})
    supervisor_name = Untether.Registry.generate_name(__MODULE__, instance_id)
    Logger.debug("starting up name #{inspect(name)} from supervisor #{inspect(supervisor_name)}")
    DynamicSupervisor.start_child(
      Untether.Registry.generate_name(__MODULE__, instance_id),
      {Untether.Communicator.Client, [socket: socket, id: unique_id, name: name, instance_id: instance_id]}
    )
  end
end
