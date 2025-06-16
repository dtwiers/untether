defmodule Untether.Layouts.Monocle do
  # alias Untether.Margin
  # alias Untether.Display
  # alias Untether.Layouts.Monocle.Config
  # alias Untether.Layouts.Monocle.State
  defstruct config: nil, state: nil

  def new(config) do
    %__MODULE__{config: config, state: nil}
  end
end

# defimpl Untether.Layout, for: Untether.Layouts.Monocle do
#   alias Untether.Window
#
#   def init(layout, config) do
#     %Untether.Layouts.Monocle{
#       config: layout.config,
#       state: State.new(layout.config, config.display)
#     }
#   end
#
#   def handle_change(layout, %{type: :window_created, window: window, display: display}, state, config) do
#     new_window = Window.new(window, Display.get_usable_display_area(display) |> Rectangle.shrink_by_margin(layout.margin))
#     state =
#       if window.type == :normal do
#         %{state | normal_windows: [window | state.normal_windows], displayed_window_index: 0}
#       else
#         %{state | special_windows: [window | state.special_windows]}
#       end
#   end
#
#   def handle_change(layout, %{type: :window_destroyed, window: window}, state, config) do
#     if window.type == :normal do
#       %{state | normal_windows: List.delete(state.normal_windows, window), displayed_window_index: nil}
#     else
#       %{state | special_windows: List.delete(state.special_windows, window)}
#     end
#   end
#
# end
