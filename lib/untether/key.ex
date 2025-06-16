defmodule Untether.Key do
  @moduledoc """
  Struct representing a key event.
  """

  @type modifier() ::
          :ctrl
          | :alt
          | :shift
          | :super
          | :num_lock
          | :caps_lock
          | :mod1
          | :mod2
          | :mod3
          | :mod4
          | :mod5
  @type t :: %__MODULE__{
          modifiers: list(modifier()),
          keysym: String.t()
        }
  defstruct modifiers: [], keysym: nil

  @available_modifiers [
    :shift,
    :ctrl,
    :alt,
    :super,
    :num_lock,
    :caps_lock,
    :mod1,
    :mod2,
    :mod3,
    :mod4,
    :mod5
  ]

  @keysym_map %{
    "a" => :xk_a,
    "b" => :xk_b,
    "c" => :xk_c,
    "d" => :xk_d,
    "e" => :xk_e,
    "f" => :xk_f,
    "g" => :xk_g,
    "h" => :xk_h,
    "i" => :xk_i,
    "j" => :xk_j,
    "k" => :xk_k,
    "l" => :xk_l,
    "m" => :xk_m,
    "n" => :xk_n,
    "o" => :xk_o,
    "p" => :xk_p,
    "q" => :xk_q,
    "r" => :xk_r,
    "s" => :xk_s,
    "t" => :xk_t,
    "u" => :xk_u,
    "v" => :xk_v,
    "w" => :xk_w,
    "x" => :xk_x,
    "y" => :xk_y,
    "z" => :xk_z,
    "0" => :xk_0,
    "1" => :xk_1,
    "2" => :xk_2,
    "3" => :xk_3,
    "4" => :xk_4,
    "5" => :xk_5,
    "6" => :xk_6,
    "7" => :xk_7,
    "8" => :xk_8,
    "9" => :xk_9,
    "space" => :xk_space,
    ";" => :xk_semicolon,
    "." => :xk_period,
    "," => :xk_comma,
    "-" => :xk_minus,
    "=" => :xk_equal,
    "[" => :xk_bracketleft,
    "]" => :xk_bracketright,
    "\\" => :xk_backslash,
    "'" => :xk_apostrophe,
    "`" => :xk_grave,
    "~" => :xk_asciitilde,
    "?" => :xk_question,
    "!" => :xk_exclam,
    "/" => :xk_slash,
    "&" => :xk_ampersand,
    "*" => :xk_asterisk,
    "$" => :xk_dollar,
    "@" => :xk_at,
    "#" => :xk_hash,
    "%" => :xk_percent,
    "^" => :xk_asciicircum,
    "_" => :xk_underscore,
    "+" => :xk_plus,
    ">" => :xk_greater,
    "<" => :xk_less,
    "|" => :xk_bar,
    "return" => :xk_return,
    "backspace" => :xk_backspace,
    "escape" => :xk_escape,
    "tab" => :xk_tab,
    "up" => :xk_up,
    "down" => :xk_down,
    "left" => :xk_left,
    "right" => :xk_right,
    "delete" => :xk_delete,
    "insert" => :xk_insert,
    "home" => :xk_home,
    "end" => :xk_end,
    "pageup" => :xk_pageup,
    "pagedown" => :xk_pagedown,
    "f1" => :xk_f1,
    "f2" => :xk_f2,
    "f3" => :xk_f3,
    "f4" => :xk_f4,
    "f5" => :xk_f5,
    "f6" => :xk_f6,
    "f7" => :xk_f7,
    "f8" => :xk_f8,
    "f9" => :xk_f9,
    "f10" => :xk_f10,
    "f11" => :xk_f11,
    "f12" => :xk_f12,
    "f13" => :xk_f13,
    "f14" => :xk_f14,
    "f15" => :xk_f15,
    "f16" => :xk_f16,
    "f17" => :xk_f17,
    "f18" => :xk_f18,
    "f19" => :xk_f19,
    "f20" => :xk_f20,
    "f21" => :xk_f21,
    "f22" => :xk_f22,
    "f23" => :xk_f23,
    "f24" => :xk_f24,
    "break" => :xk_break,
    "sys_req" => :xk_sys_req,
    "print" => :xk_print,
    "pause" => :xk_pause,
    "scroll_lock" => :xk_scroll_lock,
    "num_lock" => :xk_num_lock,
    "caps_lock" => :xk_caps_lock,
    "left_shift" => :xk_shift_l,
    "right_shift" => :xk_shift_r,
    "left_control" => :xk_control_l,
    "right_control" => :xk_control_r,
    "left_alt" => :xk_alt_l,
    "right_alt" => :xk_alt_r,
    "left_meta" => :xk_meta_l,
    "right_meta" => :xk_meta_r,
    "left_super" => :xk_super_l,
    "right_super" => :xk_super_r,
    "np0" => :xk_kp_0,
    "np1" => :xk_kp_1,
    "np2" => :xk_kp_2,
    "np3" => :xk_kp_3,
    "np4" => :xk_kp_4,
    "np5" => :xk_kp_5,
    "np6" => :xk_kp_6,
    "np7" => :xk_kp_7,
    "np8" => :xk_kp_8,
    "np9" => :xk_kp_9,
    "npenter" => :xk_kp_enter,
    "npdecimal" => :xk_kp_decimal,
    "npequal" => :xk_kp_equal,
    "npslash" => :xk_kp_slash,
    "npasterisk" => :xk_kp_asterisk,
    "npminus" => :xk_kp_minus,
    "npplus" => :xk_kp_plus,
    "npcomma" => :xk_kp_comma,
    "npdot" => :xk_kp_period,
    "monitorbrightnessup" => :xk_xf86_brightness_up,
    "monitorbrightnessdown" => :xk_xf86_brightness_down,
    "mediavolumemute" => :xk_xf86_audio_mute,
    "mediavolumedown" => :xk_xf86_audio_lower_volume,
    "mediavolumeup" => :xk_xf86_audio_raise_volume,
    "mediaplay" => :xk_xf86_audio_play,
    "mediastop" => :xk_xf86_audio_stop,
    "medianext" => :xk_xf86_audio_next,
    "mediaprev" => :xk_xf86_audio_prev,
    "mediarecord" => :xk_xf86_audio_record
  }

  def get_available_modifiers(), do: @available_modifiers

  def new(%__MODULE__{} = key) do
    key
  end

  def new(keysym, []) do
    %__MODULE__{modifiers: [], keysym: keysym}
  end

  def new(keysym, ["ctrl" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:ctrl)
  end

  def new(keysym, ["alt" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:alt)
  end

  def new(keysym, ["shift" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:shift)
  end

  def new(keysym, ["super" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:super)
  end

  def new(keysym, ["meta" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:meta)
  end

  def new(keysym, ["num_lock" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:num_lock)
  end

  def new(keysym, ["caps_lock" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:caps_lock)
  end

  def new(keysym, ["scroll_lock" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:scroll_lock)
  end

  def new(keysym, ["mod1" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:mod1)
  end

  def new(keysym, ["mod2" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:mod2)
  end

  def new(keysym, ["mod3" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:mod3)
  end

  def new(keysym, ["mod4" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:mod4)
  end

  def new(keysym, ["mod5" | modifiers]) do
    new(keysym, modifiers)
    |> add_modifier(:mod5)
  end

  def new(keysym, modifiers) do
    modifiers =
      (modifiers || [])
      |> Enum.filter(fn x -> Enum.member?(@available_modifiers, x) end)
      |> Enum.uniq()
      |> Enum.sort()

    %__MODULE__{modifiers: modifiers, keysym: keysym}
  end

  def key("C-" <> symbol) do
    add_modifier(key(symbol), :ctrl)
  end

  def key("M-" <> symbol) do
    add_modifier(key(symbol), :alt)
  end

  def key("A-" <> symbol) do
    add_modifier(key(symbol), :alt)
  end

  def key("D-" <> symbol) do
    add_modifier(key(symbol), :super)
  end

  def key("Super-" <> symbol) do
    add_modifier(key(symbol), :super)
  end

  def key("S-" <> symbol) do
    add_modifier(key(symbol), :shift)
  end

  def key("<" <> symbol) do
    symbol = String.trim(symbol, "<>")
    key(symbol)
  end

  def key(symbol) when is_binary(symbol) do
    sym = Map.get(@keysym_map, symbol, :unknown)
    new([], sym)
  end

  def key(symbol) when is_atom(symbol) do
    new([], symbol)
  end

  defp add_modifier(key, modifier) do
    new([modifier | key.modifiers], key.keysym)
  end
end
