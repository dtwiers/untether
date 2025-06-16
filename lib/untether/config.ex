defmodule Untether.Config do
  alias Untether.Config.CommunicationSettings

  @type t :: %__MODULE__{}

  defstruct [
    triggers: [],
    workspaces: [],
    window_rules: [],
    communication: nil
  ]

  def new(opts \\ []) do
    %__MODULE__{
      triggers: opts[:triggers] || [],
      workspaces: opts[:workspaces] || [],
      window_rules: opts[:window_rules] || [],
      communication: opts[:communication] || CommunicationSettings.new()
    }
  end

end
