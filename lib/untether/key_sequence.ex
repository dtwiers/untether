defmodule Untether.KeySequence do
  defstruct keys: []

  def new(keys) do
    %__MODULE__{keys: keys}
  end

  def append(%__MODULE__{keys: keys}, key) do
    %__MODULE__{keys: keys ++ [key]}
  end

  def get_keys(%__MODULE__{keys: keys}) do
    keys
  end

  def get_leader(%__MODULE__{keys: keys}) do
    Enum.at(keys, 0)
  end

end
