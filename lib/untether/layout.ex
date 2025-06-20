defprotocol Untether.Layout do
  @spec render(
          layout :: struct(),
          display :: Untether.Display.t()
        ) :: [Untether.LayoutResult.t()]
  def render(layout, display)

  @spec change(
          layout :: struct(),
          event :: term()
        ) :: struct()
  def change(layout, event)
end
