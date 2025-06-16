defmodule Untether.Layouts.Monocle.Config do
  alias Untether.Margin

  defstruct margin: nil

  def new(%{margin: margin}) do
    %__MODULE__{margin: Margin.new(margin)}
  end
end
