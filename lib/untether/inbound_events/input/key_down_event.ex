defmodule Untether.InboundEvents.Input.KeyDownEvent do
  @moduledoc """
  Struct representing a key down event.
  """

  @type modifier() :: :ctrl | :alt | :shift
  @type t :: %__MODULE__{
          key: Untether.Key.t()
        }
  defstruct key: nil
end
