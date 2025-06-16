defmodule Untether.StateMachines.DisplayServer do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    config = opts[:config]
    {:ok, %{config: config}}
  end
end
