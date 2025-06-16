defmodule Untether.Workspace do
  
  @callback init(args :: map()) :: any()

  @callback compute_layout(windows :: [Untetherwm.Window.t()], config :: Untetherwm.Config.t()) :: any()
end
