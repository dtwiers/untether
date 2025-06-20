defmodule Untether.LayoutResult do
  alias Untether.Rectangle

  @type t :: %__MODULE__{
          window_id: integer,
          rect: Rectangle.t(),
          z_index: integer | nil,
          opacity: float | nil,
          floating: boolean | nil,
          fullscreen: boolean | nil,
          focused?: boolean,
          meta: map
        }

  defstruct window_id: nil,
            rect: nil,
            z_index: nil,
            opacity: nil,
            floating: nil,
            fullscreen: nil,
            focused?: false,
            meta: %{}

  def new(opts) do
    window_id = opts[:window_id]
    rect = opts[:rect]
    z_index = opts[:z_index]
    opacity = opts[:opacity]
    floating = opts[:floating]
    fullscreen = opts[:fullscreen]
    focused? = opts[:focused?]
    meta = opts[:meta]
    %__MODULE__{
      window_id: window_id,
      rect: rect,
      z_index: z_index,
      opacity: opacity,
      floating: floating,
      fullscreen: fullscreen,
      focused?: focused?,
      meta: meta
    }
  end
end
