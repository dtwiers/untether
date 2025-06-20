defmodule Untether.Supervisor do
  @moduledoc """
  Supervisor for Untether. This is the top level supervisor in the application.
  """
  use Supervisor

  def start_link(config, opts) do
    instance_id = Keyword.get(opts, :instance_id, System.unique_integer([:positive]))

    Supervisor.start_link(__MODULE__, config: config, instance_id: instance_id)
  end

  @impl true
  def init(opts) do
    config = opts[:config]
    instance_id = opts[:instance_id]

    children =
      [
        Untether.Communicator.ClientSupervisor,
        Untether.PubSub,
        Untether.Communicator.Listener,
        Untether.StateMachines.KeyBindingServer,
        Untether.StateMachines.TriggerServer,
        Untether.StateMachines.WindowServer,
        Untether.StateMachines.DisplayServer,
        Untether.StateMachines.WorkspaceServer
      ]
      |> Enum.map(fn
        {module, opts} -> {module, opts}
        module -> {module, []}
      end)
      |> Enum.map(fn {module, opts} -> {module, Keyword.put(opts, :config, config)} end)
      |> Enum.map(fn {module, opts} -> {module, Keyword.put(opts, :instance_id, instance_id)} end)
      |> Enum.map(&normalize_child(&1, instance_id))

    Supervisor.init(children,
      strategy: :one_for_one
    )
  end

  defp normalize_child({child_module, _args} = child, instance_id) do
    Supervisor.child_spec(
      child,
      id: Untether.Registry.generate_name(child_module, instance_id)
    )
  end
end
