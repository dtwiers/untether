defmodule Untether.Supervisor do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

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
        Untether.Communicator.Listener,
        Untether.StateMachines.KeyBindingServer,
        Untether.StateMachines.TriggerServer,
        Untether.StateMachines.WindowServer,
        Untether.StateMachines.DisplayServer
      ]
      |> Enum.map(fn
        {module, opts} -> {module, opts}
        module -> {module, []}
      end)
      |> Enum.map(fn {module, opts} -> {module, Keyword.put(opts, :config, config)} end)
      |> Enum.map(fn {module, opts} -> {module, Keyword.put(opts, :instance_id, instance_id)} end)
      |> normalize_children(instance_id)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: name(Untether.Supervisor, instance_id)]
    Supervisor.init(children, opts)
  end

  def normalize_children(children, instance_id) do
    Enum.map(children, fn {child_module, _args} = child ->
      Supervisor.child_spec(
        child,
        id: Untether.Registry.generate_name(child_module, instance_id)
      )
    end)
  end

  defp name(name, supervisor_id) do
    {name, supervisor_id}
  end
end
