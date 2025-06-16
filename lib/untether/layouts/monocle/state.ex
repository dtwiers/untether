defmodule Untether.Layouts.Monocle.State do
  alias Untether.Display
  alias Untether.Layouts.Monocle.Config
  alias Untether.Margin

  defstruct normal_windows: [],
            margin: nil,
            usable_area: nil,
            output: nil

  def new(%Config{} = config, display) do
    %__MODULE__{
      margin: Margin.new(config.margin),
      usable_area: Display.get_usable_display_area(display)
    }
  end
end
