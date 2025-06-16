defmodule Untether.InboundEvents.Input.MouseWheelEvent do
  @moduledoc """
  Struct representing a mouse wheel event.
  """
  @type direction() :: :up | :down
  @type modifier() :: :ctrl | :alt | :shift
  @type t :: %__MODULE__{
          direction: direction(),
          modifiers: list(modifier()),
          x: integer,
          y: integer,
          delta_x: integer,
          delta_y: integer
        }
  @enforce_keys [:direction, :modifiers, :x, :y, :delta_x, :delta_y]
  defstruct direction: :up, modifiers: [], x: 0, y: 0, delta_x: 0, delta_y: 0

  @doc """
  Creates a new MouseWheelEvent.

  ## Parameters
    - `direction`: The scroll direction (:up or :down).
    - `modifiers`: List of active modifiers (:ctrl, :alt, :shift).
    - `x`: X-coordinate of the mouse wheel event.
    - `y`: Y-coordinate of the mouse wheel event.
    - `delta_x`: Horizontal scroll amount.
    - `delta_y`: Vertical scroll amount.
  """
  def new(direction, modifiers, x, y, delta_x, delta_y) do
    %__MODULE__{
      direction: direction,
      modifiers: modifiers,
      x: x,
      y: y,
      delta_x: delta_x,
      delta_y: delta_y
    }
  end
end
