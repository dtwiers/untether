defmodule Untether.Communicator.Router do
  def route(data, sender) do
    format_identify([], data, sender)
  end

  defp format_identify(
         actions,
         %{"type" => "identify", "data" => "compositor"} = _data,
         {:by_id, _} = _sender
       ) do
    [%{type: :identify, role: :compositor} | actions]
  end

  defp format_identify(
         actions,
         %{"type" => "identify", "data" => "control"} = _data,
         {:by_id, _} = _sender
       ) do
    [%{type: :identify, role: :control} | actions]
  end

  defp format_identify(actions, _data, _sender), do: actions

end
