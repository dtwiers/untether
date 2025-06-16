defmodule UntetherTest.Helper do
  import ExUnit.Callbacks

  def start_test_listener(opts \\ []) do
    socket_path = "/tmp/untether_test_#{System.unique_integer([:positive])}.sock"
    instance_id = Keyword.get(opts, :instance_id, System.unique_integer([:positive]))

    config =
      Keyword.get(
        opts,
        :config,
        Untether.Config.new(
          communication: Untether.Config.CommunicationSettings.new(compositor_socket: socket_path)
        )
      )
    {:ok, pid} = Untether.start(config, instance_id: instance_id)

    wait_for_socket(socket_path)

    on_exit(fn ->
      Process.exit(pid, :kill)
      if File.exists?(socket_path), do: File.rm!(socket_path)
    end)

    {:ok, %{socket_path: socket_path, instance_id: instance_id}}
  end

  def wait_for_socket(socket_path, timeout_ms \\ 500) do
    start_time = System.monotonic_time(:millisecond)

    wait = fn wait_fun ->
      if File.exists?(socket_path) do
        :ok
      else
        if System.monotonic_time(:millisecond) - start_time > timeout_ms do
          {:error, :timeout}
        else
          Process.sleep(10)
          wait_fun.(wait_fun)
        end
      end
    end

    wait.(wait)
  end
end
