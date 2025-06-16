defmodule Untether.InboundEvents.Client.IdentifyEvent do
  defstruct role: nil, source: nil
end

defimpl Untether.InboundEvent, for: Untether.InboundEvents.Client.IdentifyEvent do
  def new(%{"type" => "identify", "data" => "compositor"}, source) do
    %Untether.InboundEvents.Client.IdentifyEvent{role: :compositor, source: source}
  end
end
