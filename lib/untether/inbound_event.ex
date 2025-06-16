defprotocol Untether.InboundEvent do
  @spec new(data :: map(), source :: term()) :: struct()
  def new(data, source)
end
