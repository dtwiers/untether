defmodule Untether.Layouts.Monocle do
  alias Untether.Margin
  alias Untether.LayoutUtils.WindowStack

  @type t :: %__MODULE__{
          margin: Untether.Margin.t(),
          state: Untether.Layouts.Monocle.State.t()
        }

  defstruct margin: nil,
            state: nil

  def new(config) do
    %__MODULE__{
      margin: Map.get(config, :margin, Margin.new(0)),
      state: Untether.Layouts.Monocle.State.from_config(config)
    }
  end
end

defimpl Untether.Layout, for: Untether.Layouts.Monocle do
  alias Untether.LayoutUtils.WindowStack
  alias Untether.Margin
  import Untether.LayoutUtils.WindowStack.Guards
  alias Untether.Layouts.Monocle.State

  def render(%Untether.Layouts.Monocle{state: state} = _layout, _display) do
    case WindowStack.current_window(state.stack) do
      nil -> []
      focused_window -> [focused_window]
    end
  end

  def change(layout, {:margin, margin}) do
    update_state(layout, margin: margin)
  end

  def change(layout, action) when is_stack_action(action) do
    map_stack(
      layout,
      fn stack -> WindowStack.handle_change(stack, action) end
    )
  end

  # Apply a transformation to the current WindowStack and return an updated
  # layout struct.
  defp map_stack(%Untether.Layouts.Monocle{state: state} = layout, fun)
       when is_function(fun, 1) do
    new_stack = fun.(state.stack)
    update_state(layout, stack: new_stack)
  end

  defp update_state(%Untether.Layouts.Monocle{state: state} = layout, state_opts) do
    %Untether.Layouts.Monocle{
      layout
      | state:
          state
          |> Map.from_struct()
          |> Map.merge(state_opts |> Enum.into(%{}))
          |> State.new()
    }
  end
end
