defmodule Untether.Layouts.Monocle.State do
  alias Untether.Margin
  alias Untether.LayoutUtils.WindowStack

  @type t :: %__MODULE__{
          stack: WindowStack.t(),
          margin: Margin.t()
        }

  defstruct stack: WindowStack.new(),
            margin: nil

  def new(%__MODULE__{
        margin: margin,
        stack: stack
      })
      when margin == nil do
    %__MODULE__{
      margin: margin || Margin.new(0),
      stack: stack || WindowStack.new()
    }
  end

  def new(%{} = attrs) do
    %__MODULE__{
      margin: attrs[:margin] || Margin.new(0),
      stack: attrs[:stack] || WindowStack.new()
    }
  end

  def from_config(%{} = config) do
    %__MODULE__{
      margin: Map.get(config, :margin, Margin.new(0)) |> Margin.new(),
      stack: WindowStack.new()
    }
  end
end
