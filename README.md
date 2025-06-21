# Untether

![Untether Logo](https://github.com/dtwiers/untether/blob/5b1fe31ab412803cbf200daada926eb011b9f7f5/Untether.png?raw=true, "Logo")

Untether is a Wayland Compositor written and configured in Elixir. It uses Zig for the performance critical bits,
but all of the logic takes advantage of the BEAM. It is intended to be as flexible as possible with your
configuration being the entrypoint that calls the runtime, not the other way around (like xmonad).

This is intended to be a Wayland First compositor. I do not have any plans to backport this to X.

I started writing this because there is no spiritual successor to XMonad or Qtile in Wayland, and I wanted
a compositor that was both performant and configurable in much the same way. And...I'm an Elixir dev.

For now, it's entirely non-functional and is in the early stages of development, but I'm working up a test
suite, and once I get some sane defaults in place and a (barely) working Elixir side, I'll start on the
Zig side.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `untether` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:untether, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/untether>.

