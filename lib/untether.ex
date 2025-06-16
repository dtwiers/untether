defmodule Untether do
  alias Untether.Config

  def start(%Config{} = config, opts \\ []) do
    Logger.configure(level: :debug)
    Untether.Registry.ensure_started()

    instance_id = Keyword.get(opts, :instance_id, System.unique_integer([:positive]))
    Untether.Supervisor.start_link(config, instance_id: instance_id)
  end
end
