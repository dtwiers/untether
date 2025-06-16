defmodule Untether.InboundEvents.Input.MouseDownEvent do
  @moduledoc """
  Struct representing a mouse down event.
  """

  @type modifier() :: :ctrl | :alt | :shift
  @type t :: %__MODULE__{
          button_code: 256..279,
          button_type: :left | :middle | :right | :back | :forward | nil,
          modifiers: list(modifier()),
          x: integer,
          y: integer
        }
  @enforce_keys [:button_code, :modifiers, :x, :y]
  defstruct button_code: 272, button_type: nil, modifiers: [], x: 0, y: 0

  def new(
        button_code,
        x,
        y,
        modifiers \\ []
      ) do
    button_type =
      case button_code do
        272 -> :left
        273 -> :middle
        274 -> :right
        275 -> :back
        276 -> :forward
        _ -> nil
      end

    %__MODULE__{
      button_code: button_code,
      button_type: button_type,
      modifiers: modifiers,
      x: x,
      y: y
    }
  end
end
