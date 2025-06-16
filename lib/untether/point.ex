defmodule Untether.Point do
  defstruct [
    x: 0,
    y: 0
  ]

  def new(x, y) do
    %__MODULE__{x: x, y: y}
  end

  # note: don't use %Untether.Rectangle{} due to cyclic dependency
  def in_rectangle?(%__MODULE__{x: x, y: y}, %{x: x1, y: y1, width: width, height: height}) do
    x >= x1 && x <= x1 + width && y >= y1 && y <= y1 + height
  end
end
