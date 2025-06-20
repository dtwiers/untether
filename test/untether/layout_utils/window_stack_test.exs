defmodule Untether.LayoutUtils.WindowStackTest do
  use ExUnit.Case
  alias Untether.LayoutUtils.WindowStack

  doctest WindowStack

  defmacrop create_windows(ids) do
    ids =
      case ids do
        {:__block__, _, values} -> values
        list when is_list(list) -> list
        _ -> raise "Invalid arguments to create_windows"
      end

    value =
      for id <- ids do
        quote do: %{id: unquote(id)}
      end

    quote do: [unquote_splicing(value)]
  end

  test "normalize" do
    stack = WindowStack.new(windows: create_windows([1, 2, 3]), current_index: 1)

    assert %WindowStack{windows: create_windows([2, 3, 1]), current_index: 0, wrap?: true} =
             WindowStack.normalize(stack)

    stack = WindowStack.new(windows: create_windows([1, 2, 3]), current_index: 0)

    assert %WindowStack{windows: create_windows([1, 2, 3]), current_index: 0, wrap?: true} =
             WindowStack.normalize(stack)

    stack = WindowStack.new(windows: create_windows([1, 2, 3]), current_index: 2)

    assert %WindowStack{windows: create_windows([3, 1, 2]), current_index: 0, wrap?: true} =
             WindowStack.normalize(stack)
  end
end
