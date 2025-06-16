defprotocol Untether.OutboundEvent do
  @spec new(data :: map(), destination :: term()) :: struct()
  def new(data, destination)
end
