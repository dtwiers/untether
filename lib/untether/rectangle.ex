defmodule Untether.Rectangle do
  alias Untether.Margin
  alias Untether.Point

  @type t :: %__MODULE__{
          x: integer,
          y: integer,
          width: integer,
          height: integer
        }

  defstruct x: 0,
            y: 0,
            width: 0,
            height: 0

  def is_subset_of(%__MODULE__{} = object, %__MODULE__{} = target) do
    {start_point, end_point} = get_diagonal_points(object)
    Point.in_rectangle?(start_point, target) && Point.in_rectangle?(end_point, target)
  end

  def shrink_by_margin(
        %__MODULE__{} = object,
        %Margin{left: left, right: right, top: top, bottom: bottom} = _margin
      ) do
    %__MODULE__{
      x: object.x + left,
      y: object.y + top,
      width: object.width - left - right,
      height: object.height - top - bottom
    }
  end

  defp get_diagonal_points(%__MODULE__{x: x, y: y, width: width, height: height} = _object) do
    start_point = %Point{x: x, y: y}
    end_point = %Point{x: x + width, y: y + height}
    {start_point, end_point}
  end
end
