defmodule Untether.Config.CommunicationSettings do
  require Logger

  defstruct [
    :compositor_socket
  ]

  @default_socket_name "untether-compositor.sock"

  def new(opts \\ []) do
    compositor_socket =
      cond do
        from_opts = opts[:compositor_socket] ->
          from_opts

        from_env = System.get_env("UNTETHER_COMPOSITOR_SOCKET") ->
          from_env

        System.get_env("XDG_RUNTIME_DIR") ->
          "#{System.get_env("XDG_RUNTIME_DIR")}/#{@default_socket_name}"

        true ->
          Logger.warning(
            "Unix socket for compositor not specified.  Using default /tmp/#{@default_socket_name}"
          )

          "/tmp/#{@default_socket_name}"
      end

    %__MODULE__{
      compositor_socket: compositor_socket
    }
  end
end
