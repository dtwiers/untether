defmodule Untether.Registry do
  @moduledoc """
  A globally-shared Registry for all Untether instances.
  """
  require Logger

  @name __MODULE__

  def ensure_started do
    case Process.whereis(@name) do
      nil ->
        Logger.debug("Starting registry")
        Registry.start_link(keys: :unique, name: @name)
      pid ->
        Logger.debug("Registry already started; pid=#{inspect(pid)}")
        {:ok, pid}
    end
  end

  def name, do: @name

  def lookup(name, instance_id) do
    Registry.lookup(Untether.Registry, {name, instance_id})
  end

  def generate_name(name, instance_id) do
    {:via, Registry, {Untether.Registry, {name, instance_id}}}
  end

  def generate_name(:client, instance_id, name) do
    {:via, Registry, {__MODULE__, {:client, name, instance_id}}}
  end

  def lookup(:client, instance_id, name) do
    Logger.debug("Looking up client #{name} in instance #{instance_id}")
    entries = Registry.select(Untether.Registry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    Logger.debug("Registry entries: #{inspect(entries)}")
    Registry.lookup(Untether.Registry, {:client, name, instance_id})
  end

  def rename(:client, instance_id, old_id, role) do
    Registry.unregister(Untether.Registry, {:client, old_id, instance_id})
    Registry.register(Untether.Registry, {:client, role, instance_id}, {})
  end

end
