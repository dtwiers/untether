defmodule UntetherTest do
  use ExUnit.Case
  doctest Untether

  test "start...does something" do
    assert {:ok, _supervisor_pid} = Untether.start(Untether.Config.new())
  end
end
