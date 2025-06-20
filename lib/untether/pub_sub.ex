defmodule Untether.PubSub do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, []}
  end

  def subscribe(instance_id, topic) do
    GenServer.call(__MODULE__, {:subscribe, instance_id, topic})
  end
end
