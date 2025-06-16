defmodule Untether.Keybinding do
  defstruct trigger: nil, action: nil

  def new(trigger, action) do
    %__MODULE__{trigger: trigger, action: action}
  end

  # def parse({trigger_str, action}) do
  # end
  # def foo() do
  #   leader = key("C-\\")
  #   [
  #     {key("C-s"), fn -> open("spotify") end},
  #     {sequence([leader, key([], "x")]), fn -> open("spotify") end}
  #   ]
  # end
end
