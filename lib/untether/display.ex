defmodule Untether.Display do
  alias Untether.Rectangle

  @type t :: %__MODULE__{
          id: integer,
          raw_dimensions: Rectangle.t(),
          usable_dimensions: Rectangle.t()
        }
  defstruct id: nil,
            raw_dimensions: nil,
            usable_dimensions: nil

  def new(id, width, height) do
    %__MODULE__{
      id: id,
      raw_dimensions: %Rectangle{x: 0, y: 0, width: width, height: height},
      usable_dimensions: %Rectangle{x: 0, y: 0, width: width, height: height}
    }
  end

  def set_usable_dimensions(%__MODULE__{} = display, %Rectangle{} = rectangle) do
    %__MODULE__{display | usable_dimensions: rectangle}
  end

  def get_usable_display_area(
        %__MODULE__{usable_dimensions: %Rectangle{width: width, height: height}} = _display
      ) do
    %Rectangle{x: 0, y: 0, width: width, height: height}
  end
end
