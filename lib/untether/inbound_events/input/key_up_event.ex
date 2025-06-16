defmodule Untether.InboundEvents.Input.KeyUpEvent do
  @moduledoc """
  Struct representing a key up event.
  """

  @type modifier() :: :ctrl | :alt | :shift
  @type t :: %__MODULE__{
          key: Untether.Key.t()
        }
  defstruct key: nil
end
