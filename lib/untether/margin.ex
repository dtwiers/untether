defmodule Untether.Margin do
  @type t :: %__MODULE__{
          left: integer,
          right: integer,
          top: integer,
          bottom: integer
        }
  defstruct left: 0,
            right: 0,
            top: 0,
            bottom: 0

  def new(left, right, top, bottom) do
    %__MODULE__{left: left, right: right, top: top, bottom: bottom}
  end

  def new(vertical, horizontal) do
    %__MODULE__{left: horizontal, right: horizontal, top: vertical, bottom: vertical}
  end

  def new(%__MODULE__{} = margin) do
    margin
  end

  def new(nil) do
    %__MODULE__{left: 0, right: 0, top: 0, bottom: 0}
  end

  def new(margin) do
    %__MODULE__{left: margin, right: margin, top: margin, bottom: margin}
  end

  def add(margin, left, right, top, bottom) do
    %__MODULE__{
      left: margin.left + left,
      right: margin.right + right,
      top: margin.top + top,
      bottom: margin.bottom + bottom
    }
  end

  def add(margin, vertical, horizontal) do
    %__MODULE__{
      left: margin.left + horizontal,
      right: margin.right + horizontal,
      top: margin.top + vertical,
      bottom: margin.bottom + vertical
    }
  end

  def add(margin, %__MODULE__{} = margin2) do
    %__MODULE__{
      left: margin.left + margin2.left,
      right: margin.right + margin2.right,
      top: margin.top + margin2.top,
      bottom: margin.bottom + margin2.bottom
    }
  end

  def add(margin, margin2) do
    add(margin, margin2, margin2, margin2, margin2)
  end
end
