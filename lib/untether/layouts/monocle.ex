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

  def render(%Untether.Layouts.Monocle{state: state} = _layout, _display) do
    case WindowStack.current_window(state.stack) do
      nil -> []
      focused_window -> [focused_window]
    end
  end

  def change(layout, {:add_window, window}) do
    map_stack(layout, &WindowStack.add_window(&1, window))
  end

  def change(layout, {:remove_window, window}) do
    map_stack(layout, &WindowStack.remove_window(&1, window))
  end

  def change(layout, {:focus_window, window}) do
    map_stack(layout, &WindowStack.focus_window(&1, window))
  end

  def change(layout, {:demote_window, window}) do
    position = WindowStack.position(layout.state.stack, window)
    size = WindowStack.size(layout.state.stack)

    if position == size - 1 do
      layout
    else
      map_stack(
        layout,
        fn stack -> WindowStack.move_window(stack, window, 1) end
      )
    end
  end

  def change(layout, {:promote_window, window}) do
    position = WindowStack.position(layout.state.stack, window)

    if position == 1 do
      layout
    else
      map_stack(
        layout,
        fn stack -> WindowStack.move_window(stack, window, -1) end
      )
    end
  end

  def change(layout, :focus_next) do
    map_stack(
      layout,
      fn stack -> WindowStack.focus_next(stack) end
    )
  end

  def change(layout, :focus_prev) do
    map_stack(
      layout,
      fn stack -> WindowStack.focus_previous(stack) end
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
