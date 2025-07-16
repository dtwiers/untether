defmodule Untether.LayoutUtils.WindowStack.Guards do
  defguardp is_stack_action_atom(action) when action in [:focus_next, :focus_prev]

  defguardp is_stack_action_tuple(action)
            when is_tuple(action) and
                   elem(action, 0) in [
                     :add_window,
                     :remove_window,
                     :focus_window,
                     :demote_window,
                     :promote_window
                   ]

  defguard is_stack_action(action)
           when is_stack_action_atom(action) or is_stack_action_tuple(action)
end
