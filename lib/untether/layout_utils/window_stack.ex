defmodule Untether.LayoutUtils.WindowStack do
  @moduledoc """
  Struct representing a window stack.
  """

  @type t :: %__MODULE__{
          windows: [Untether.Window.t()],
          current_index: integer,
          wrap?: boolean
        }

  defstruct windows: [], current_index: 0, wrap?: true

  @doc """
  Creates a new window stack.

  ## Examples

      iex> Untether.LayoutUtils.WindowStack.new()
      %Untether.LayoutUtils.WindowStack{windows: [], current_index: 0, wrap?: true}
  """
  @spec new() :: %__MODULE__{}
  def new(), do: %__MODULE__{}

  @doc """
  Creates a new window stack.

  ## Examples

      iex> Untether.LayoutUtils.WindowStack.new(wrap?: false)
      %Untether.LayoutUtils.WindowStack{windows: [], current_index: 0, wrap?: false}
  """
  @spec new(Keyword.t()) :: %__MODULE__{}
  def new(opts), do: struct(__MODULE__, opts)

  @doc """
  Focuses the next window in the stack. Wraps if `wrap` is `true`.

  ## Examples

      iex> Untether.LayoutUtils.WindowStack.new(windows: [1, 2, 3]) |> Untether.LayoutUtils.WindowStack.focus_next()
      %Untether.LayoutUtils.WindowStack{windows: [1, 2, 3], current_index: 1, wrap?: true}
  """
  @spec focus_next(%__MODULE__{}) :: %__MODULE__{}
  def focus_next(%__MODULE__{} = window_stack) do
    %{
      window_stack
      | current_index: Integer.mod(window_stack.current_index + 1, length(window_stack.windows))
    }
  end

  def focus_window(%__MODULE__{} = window_stack, window) do
    case find_window_index(window_stack, window) do
      nil -> window_stack
      index -> %{window_stack | current_index: index}
    end
  end

  @doc """
  Focuses the previous window in the stack. Wraps if `wrap` is `true`.

  ## Examples

      iex> Untether.LayoutUtils.WindowStack.new(windows: [1, 2, 3]) |> Untether.LayoutUtils.WindowStack.focus_previous()
      %Untether.LayoutUtils.WindowStack{windows: [1, 2, 3], current_index: 2, wrap?: true}
  """
  @spec focus_previous(%__MODULE__{}) :: %__MODULE__{}
  def focus_previous(%__MODULE__{} = window_stack) do
    %{
      window_stack
      | current_index: Integer.mod(window_stack.current_index - 1, length(window_stack.windows))
    }
  end

  @doc """
  Returns the currently focused window in the stack.
  """
  @spec current_window(%__MODULE__{}) :: Untether.Window.t() | nil
  def current_window(%__MODULE__{} = window_stack) do
    Enum.at(window_stack.windows, window_stack.current_index)
  end

  @doc """
  Normalizes the window stack by moving the current window to the front of the stack and rotating the stack to compensate, keeping the same overall (wrapped) order of windows. Not recommended for stacks that are not wrapped.

  ## Examples

      iex> Untether.LayoutUtils.WindowStack.new(windows: [1, 2, 3], current_index: 1) |> Untether.LayoutUtils.WindowStack.normalize()
      %Untether.LayoutUtils.WindowStack{windows: [2, 3, 1], current_index: 0, wrap?: true}
  """
  @spec normalize(%__MODULE__{}) :: %__MODULE__{}
  def normalize(%__MODULE__{windows: windows, current_index: current_index}) do
    {head, tail} = Enum.split(windows, current_index)
    stack = tail ++ head

    %__MODULE__{windows: stack, current_index: 0}
  end

  @doc """
  Adds a window to the stack. Sets the current window to the new window.
  """
  def add_window(%__MODULE__{} = window_stack, window) do
    stack =
      window_stack
      |> normalize()

    %__MODULE__{stack | windows: [window | stack.windows]}
  end

  def remove_window(%__MODULE__{current_index: current_index} = window_stack, window) do
    Enum.find_index(window_stack.windows, &(&1 == window))
    |> case do
      nil ->
        window_stack

      ^current_index ->
        %__MODULE__{window_stack | windows: List.delete(window_stack.windows, window)}

      index when index < current_index ->
        %__MODULE__{
          window_stack
          | windows: List.delete(window_stack.windows, window),
            current_index: window_stack.current_index - 1
        }

      index when index > current_index ->
        %__MODULE__{
          window_stack
          | windows: List.delete(window_stack.windows, window),
            current_index: window_stack.current_index
        }
    end
  end

  def swap_windows_by_index(%__MODULE__{} = window_stack, index1, index2) do
    window1 = Enum.at(window_stack.windows, index1)
    window2 = Enum.at(window_stack.windows, index2)

    windows =
      List.replace_at(window_stack.windows, index1, window2)
      |> List.replace_at(index2, window1)

    %__MODULE__{window_stack | windows: windows}
  end

  def swap_windows(%__MODULE__{} = window_stack, window1, window2) do
    index1 = find_window_index(window_stack, window1)
    index2 = find_window_index(window_stack, window2)

    if index1 == nil or index2 == nil do
      window_stack
    else
      windows =
        List.replace_at(window_stack.windows, index1, window2)
        |> List.replace_at(index2, window1)

      %__MODULE__{window_stack | windows: windows}
    end
  end

  def move_window(%__MODULE__{current_index: current_index} = window_stack, window, delta) do
    index = find_window_index(window_stack, window)

    if index == nil do
      window_stack
    else
      new_index = Integer.mod(index + delta, length(window_stack.windows))

      {was, now} = {compare(index, current_index), compare(new_index, current_index)}

      new_current_index =
        case {was, now} do
          {same, same} -> current_index
          {:eq, _} -> new_index
          {:lt, :gt} -> current_index - 1
          {:gt, _} -> current_index + 1
          {:lt, _} -> current_index
        end

      delete_from_index = index

      add_to_index =
        case compare(new_index, index) do
          :lt -> new_index
          :gt -> new_index
          :eq -> new_index
        end

      %__MODULE__{
        window_stack
        | windows:
            List.delete_at(window_stack.windows, delete_from_index)
            |> List.insert_at(add_to_index, window),
          current_index: new_current_index
      }
    end
  end

  def empty?(%__MODULE__{windows: []}), do: true
  def empty?(%__MODULE__{}), do: false

  def size(%__MODULE__{windows: windows}), do: length(windows)

  def contains?(%__MODULE__{windows: windows}, window), do: window in windows

  def find_window_index(%__MODULE__{} = window_stack, %{window_id: window_id} = _window) do
    Enum.find_index(window_stack.windows, &(&1.window_id == window_id))
  end

  def position(%__MODULE__{wrap?: true} = window_stack, window) do
    target_index = find_window_index(window_stack, window)

    if target_index == nil do
      nil
    else
      Integer.mod(target_index - window_stack.current_index, length(window_stack.windows))
    end
  end

  def demote_window(%__MODULE__{} = window_stack, window) do
    position = position(window_stack, window)
    size = size(window_stack)

    if position == size - 1 do
      window_stack
    else
      move_window(window_stack, window, 1)
    end
  end

  def promote_window(%__MODULE__{} = window_stack, window) do
    position = position(window_stack, window)

    if position == 1 do
      window_stack
    else
      move_window(window_stack, window, -1)
    end
  end

  def handle_change(%__MODULE__{} = window_stack, {:add_window, window}) do
    add_window(window_stack, window)
  end

  def handle_change(%__MODULE__{} = window_stack, {:remove_window, window}) do
    remove_window(window_stack, window)
  end

  def handle_change(%__MODULE__{} = window_stack, {:focus_window, window}) do
    focus_window(window_stack, window)
  end

  def handle_change(%__MODULE__{} = window_stack, {:demote_window, window}) do
    demote_window(window_stack, window)
  end

  def handle_change(%__MODULE__{} = window_stack, {:promote_window, window}) do
    promote_window(window_stack, window)
  end

  def handle_change(%__MODULE__{} = window_stack, :focus_next) do
    focus_next(window_stack)
  end

  def handle_change(%__MODULE__{} = window_stack, :focus_prev) do
    focus_previous(window_stack)
  end

  defp compare(a, b) do
    cond do
      a == b -> :eq
      a < b -> :lt
      a > b -> :gt
    end
  end
end
