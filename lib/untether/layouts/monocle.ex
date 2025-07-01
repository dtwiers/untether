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
  alias Untether.LayoutUtils.WindowStack
  import Untether.LayoutUtils.WindowStack, only: [is_stack_action: 1]

  def render(%Untether.Layouts.Monocle{state: state} = _layout, _display) do
    case WindowStack.current_window(state.stack) do
      nil -> []
      focused_window -> [focused_window]
    end
  end

  def change(layout, {:margin, margin}) do
    update_state(layout, %WindowStack{layout.state.stack | margin: margin})
  end

  def change(layout, action) do
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
    update_state(layout, new_stack)
  end

  # Replace the stack inside the nested State struct keeping everything else
  # untouched.
  defp update_state(%Untether.Layouts.Monocle{state: state} = layout, %WindowStack{} = new_stack) do
    %Untether.Layouts.Monocle{
      layout
      | state: %Untether.Layouts.Monocle.State{state | stack: new_stack}
    }
  end
end
