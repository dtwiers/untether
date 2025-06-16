defprotocol Untether.Layout do
  def render(layout, display)
  def handle_change(layout, changes, state, config)
  def get_input_hooks(layout)
end
