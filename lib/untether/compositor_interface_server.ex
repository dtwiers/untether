defmodule Untether.CompositorInterfaceServer do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get_workspace, _from, state) do
    {:reply, state, state}
  end

end
