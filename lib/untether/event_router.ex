defmodule Untether.EventRouter do
  alias Untether.InboundEvents.Client
  alias Untether.InboundEvents.Input
  require Logger

  def parse_event(%{"type" => "identify", "data" => %{"role" => "compositor"}}, {:by_id, source}) do
    %Client.IdentifyEvent{role: :compositor, source: source}
  end

  def parse_event(%{"type" => "identify", "data" => %{"role" => "control"}}, {:by_id, source}) do
    %Client.IdentifyEvent{role: :control, source: source}
  end

  def parse_event(
        %{"type" => "key_down", "data" => %{"keysym" => key, "modifiers" => modifiers}},
        _source
      ) do
    %Input.KeyDownEvent{key: Untether.Key.new(key, modifiers)}
  end

  def parse_event(
        %{"type" => "key_up", "data" => %{"keysym" => key, "modifiers" => modifiers}},
        _source
      ) do
    %Input.KeyUpEvent{key: Untether.Key.new(key, modifiers)}
  end

  def parse_event(
        %{
          "type" => "mouse_down",
          "data" => %{"button_code" => button, "modifiers" => modifiers, "x" => x, "y" => y}
        },
        _source
      )
      when button in 256..279//1 do
    Input.MouseDownEvent.new(button, modifiers, x, y)
  end

  def parse_event(
        %{
          "type" => "mouse_up",
          "data" => %{"button_code" => button, "modifiers" => modifiers, "x" => x, "y" => y}
        },
        _source
      )
      when button in 256..279//1 do
    Input.MouseUpEvent.new(button, modifiers, x, y)
  end

  def parse_event(data, source) do
    Logger.warning("Unknown event #{inspect(data)} from #{inspect(source)}")
    nil
  end
end
