defmodule Untether.InboundEvents.Input.MouseMoveEvent do
  @moduledoc """
  Struct representing a mouse move event.
  """
  @type modifier() :: :ctrl | :alt | :shift
  @type t :: %__MODULE__{
          modifiers: list(modifier()),
          x: integer,
          y: integer
        }
  @enforce_keys [:modifiers, :x, :y]
  defstruct modifiers: [], x: 0, y: 0

  def new(x, y, modifiers \\ []) do
    %__MODULE__{modifiers: modifiers, x: x, y: y}
  end
end
