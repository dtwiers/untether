defmodule Untether.Layouts.MonocleTest do
  use ExUnit.Case, async: true

  alias Untether.Layout
  alias Untether.Layouts.Monocle
  alias Untether.Margin

  defmacrop create_windows(ids) do
    ids =
      case ids do
        {:__block__, _, values} -> values
        list when is_list(list) -> list
        _ -> raise "Invalid arguments to create_windows"
      end

    value =
      for id <- ids do
        quote do: %{window_id: unquote(id)}
      end

    quote do: [unquote_splicing(value)]
  end

  test "inits state" do
    layout = Monocle.new(%{margin: Margin.new(0)})
    assert layout.state != nil
    assert layout.state.stack.windows == []
    assert layout.state.stack.current_index == 0
    assert layout.state.margin == Margin.new(0)
  end

  test "inits from no attrs" do
    layout = Monocle.new(%{})
    assert layout.margin == Margin.new(0)
    assert layout.state.margin == Margin.new(0)
    assert layout.state.stack.windows == []
    assert layout.state.stack.current_index == 0
  end

  describe "Layout.render/2" do
    test "render empty" do
      layout = Monocle.new(%{margin: Margin.new(0)})
      assert Layout.render(layout, nil) == []
    end
  end

  describe "Layout.change/2" do
    setup do
      [layout: monocle_fixture()]
    end

    test "add window", %{layout: layout} do
      assert_stack(
        layout
        |> Layout.change({:add_window, %{window_id: 1}}),
        windows: create_windows([1]),
        current_index: 0
      )
    end

    test "add multiple windows, should add to head", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 0
      )
    end

    test "remove nonexistent window", %{layout: layout} do
      assert Layout.change(layout, {:remove_window, %{window_id: 1}}) == layout
    end

    test "remove window", %{layout: layout} do
      added = Layout.change(layout, {:add_window, %{window_id: 1}})
      assert Layout.change(added, {:remove_window, %{window_id: 1}}) == layout
    end

    test "focus window", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change({:focus_window, %{window_id: 2}})

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 1
      )
    end

    test "focus nonexistent window", %{layout: layout} do
      assert Layout.change(layout, {:focus_window, %{window_id: 1}}) == layout
    end

    test "demote lone window", %{layout: layout} do
      layout = Layout.change(layout, {:add_window, %{window_id: 1}})
      assert Layout.change(layout, {:demote_window, %{window_id: 1}}) == layout
    end

    test "demote window", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change({:demote_window, %{window_id: 2}})

      assert_stack(layout,
        windows: create_windows([1, 3, 2]),
        current_index: 0
      )
    end

    test "demote window does not wrap from end", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change({:demote_window, %{window_id: 3}})

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 0
      )
    end

    test "promote lone window", %{layout: layout} do
      layout = Layout.change(layout, {:add_window, %{window_id: 1}})
      assert Layout.change(layout, {:promote_window, %{window_id: 1}}) == layout
    end

    test "promote window", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change({:promote_window, %{window_id: 1}})

      assert_stack(layout,
        windows: create_windows([2, 3, 1]),
        current_index: 2
      )
    end

    test "promote window does not wrap from start", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change(:focus_next)
        |> Layout.change({:promote_window, %{window_id: 3}})

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 1
      )
    end

    # TODO: figure out if window promo/demo when target is under focus should have focus follow window or position

    test "focus next lone window", %{layout: layout} do
      layout = Layout.change(layout, {:add_window, %{window_id: 1}})
      assert Layout.change(layout, :focus_next) == layout
    end

    test "focus next window", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change(:focus_next)

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 1
      )
    end

    test "focus prev lone window", %{layout: layout} do
      layout = Layout.change(layout, {:add_window, %{window_id: 1}})
      assert Layout.change(layout, :focus_prev) == layout
    end

    test "focus prev window", %{layout: layout} do
      layout =
        layout
        |> Layout.change({:add_window, %{window_id: 3}})
        |> Layout.change({:add_window, %{window_id: 2}})
        |> Layout.change({:add_window, %{window_id: 1}})
        |> Layout.change(:focus_prev)

      assert_stack(layout,
        windows: create_windows([1, 2, 3]),
        current_index: 2
      )
    end
  end

  defp assert_stack(layout, opts) do
    stack = layout.state.stack
    expected_windows = opts[:windows]
    expected_current_index = opts[:current_index]

    case {expected_windows, expected_current_index} do
      {nil, nil} ->
        nil

      {nil, _} ->
        assert stack.current_index == expected_current_index

      {_, nil} ->
        assert stack.windows == expected_windows

      _ ->
        # Assert both so the error message is better
        expected = %{
          windows: expected_windows,
          current_index: expected_current_index
        }

        actual = %{
          windows: stack.windows,
          current_index: stack.current_index
        }

        assert expected == actual
    end

    if Keyword.has_key?(opts, :windows) do
      assert stack.windows == opts[:windows]
    end

    if Keyword.has_key?(opts, :focused_window_index) do
      assert stack.focused_window_index == opts[:focused_window_index]
    end
  end

  defp monocle_fixture(attrs \\ %{}, opts \\ []) do
    merged_attrs =
      %{
        margin: Margin.new(12)
      }
      |> Map.merge(attrs)

    state =
      cond do
        opts[:state] != nil -> opts[:state] |> Untether.Layouts.Monocle.State.new()
        true -> Untether.Layouts.Monocle.State.from_config(merged_attrs)
      end

    merged_attrs
    |> Map.put_new(:state, state)
    |> Monocle.new()
  end
end

