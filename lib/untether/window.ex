defmodule Untether.Window do
  @moduledoc """
  Canonical, *protocol-agnostic* description of a top-level surface.

  Anything that only the compositor itself cares about (wl_surface ptrs,
  configure serials, etc.) stays on the Zig side.  Everything user-facing
  or layout-relevant lives here.
  """

  alias Untether.Rectangle
  alias Untether.Margin

  @typedoc "xdg-shell state flags"
  @type xdg_state ::
          :activated
          | :fullscreen
          | :maximized
          | :minimized
          | :resizing
          | :tiled_left
          | :tiled_right
          | :tiled_top
          | :tiled_bottom
          | :suspended

  @typedoc "`wlr-layer-shell` Z-order bucket"
  @type layer_shell_layer :: :overlay | :top | :bottom | :background

  @typedoc "`wlr-layer-shell` edge anchors"
  @type anchor_edge :: :top | :bottom | :left | :right

  @type t :: %__MODULE__{
          id: term(),
          pid: pos_integer() | nil,
          xwayland?: boolean(),
          title: String.t() | nil,
          app_id: String.t() | nil,
          class: String.t() | nil,
          parent: term() | nil,
          states: [xdg_state()],
          geometry: Rectangle.t(),
          min_size: {non_neg_integer(), non_neg_integer()},
          max_size: {non_neg_integer(), non_neg_integer()},
          # layer-shell
          layer: layer_shell_layer() | nil,
          anchor: [anchor_edge()],
          exclusive_zone: integer() | nil,
          margin: Margin.t() | nil,
          keyboard_interactivity: :none | :exclusive | :on_demand | nil,
          # misc
          outputs: [term()],
          activation_token: String.t() | nil,
          extras: map()
        }

  @enforce_keys [:id]
  defstruct id: nil,
            pid: nil,
            xwayland?: false,
            title: nil,
            app_id: nil,
            class: nil,
            parent: nil,
            states: [],
            geometry: %Rectangle{},
            min_size: {0, 0},
            max_size: {0, 0},
            layer: nil,
            anchor: [],
            exclusive_zone: nil,
            margin: nil,
            keyboard_interactivity: nil,
            outputs: [],
            activation_token: nil,
            extras: %{}
end
