defmodule Untether.StateMachines.KeyBindingServer do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, []}
  end
end
