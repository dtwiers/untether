defmodule Untether.Window do
  alias Untether.Rectangle

  @type t :: %__MODULE__{}

  defstruct id: nil,
            app_id: nil,
            class: nil,
            title: nil,
            dimensions: nil,
            workspace: nil,
            tags: [],
            configuration_overrides: [],
            type: nil

  def new(
        %{id: id, app_id: app_id, class: class, title: title, width: width, height: height} =
          _attrs
      ) do
    %__MODULE__{
      id: id,
      app_id: app_id,
      class: class,
      title: title,
      dimensions: %Rectangle{x: 0, y: 0, width: width, height: height}
    }
  end

  def new(
        %{id: id, app_id: app_id, class: class, title: title} = _attrs,
        %Rectangle{} = target_dimensions
      ) do
    %__MODULE__{
      id: id,
      app_id: app_id,
      class: class,
      title: title,
      dimensions: target_dimensions
    }
  end

  def resize(window, width, height) do
    %__MODULE__{window | dimensions: %Rectangle{window.dimensions | width: width, height: height}}
  end

  def move(window, x, y) do
    %__MODULE__{window | dimensions: %Rectangle{window.dimensions | x: x, y: y}}
  end

  def validate(window, usable_area) do

    Rectangle.is_subset_of(window.dimensions, usable_area)
  end
end
