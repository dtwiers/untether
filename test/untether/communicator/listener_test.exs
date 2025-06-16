defmodule Untether.Communicator.ListenerTest do
  use ExUnit.Case, async: true
  import UntetherTest.Helper

  setup do
    start_test_listener()
  end

  test "client can connect and identify as compositor", %{
    socket_path: socket_path,
    instance_id: instance_id
  } do
    {:ok, socket} = :gen_tcp.connect({:local, socket_path}, 0, [:binary, {:active, false}])

    # Send identification
    msg =
      JSON.encode!(%{
        type: "identify",
        data: "compositor"
      })

    :ok = :gen_tcp.send(socket, msg)

    # Give it a moment for GenServer to process
    Process.sleep(50)

    # Check Registry state
    [{pid, _}] = Untether.Registry.lookup(:client, instance_id, :compositor)
    assert Process.alive?(pid)

    # Cleanup
    :gen_tcp.close(socket)
  end

  test "server can serve two clients", %{socket_path: socket_path, instance_id: instance_id} do
    {:ok, socket1} = :gen_tcp.connect({:local, socket_path}, 0, [:binary, {:active, false}])
    {:ok, socket2} = :gen_tcp.connect({:local, socket_path}, 0, [:binary, {:active, false}])

    # Give it a moment for GenServer to process
    Process.sleep(50)

    # Check Registry state
    assert [
             {{Untether.Communicator.ClientSupervisor, ^instance_id}, _supervisor_pid, _sup_val},
             {{:client, {:by_id, _}, ^instance_id}, pid1, _value1},
             {{:client, {:by_id, _}, ^instance_id}, pid2, _value2}
           ] =
             Registry.select(Untether.Registry, [
               {{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}
             ])
             |> Enum.sort()

    assert Process.alive?(pid1)
    assert Process.alive?(pid2)

    msg =
      JSON.encode!(%{
        type: "misc",
        data: %{
          foo: "bar"
        }
      })

    :ok = :gen_tcp.send(socket1, msg)
    :ok = :gen_tcp.send(socket2, msg)

    # Check Registry state
    assert [
             {{Untether.Communicator.ClientSupervisor, ^instance_id}, _supervisor_pid, _value1},
             {{:client, {:by_id, _}, ^instance_id}, pid1, _value3},
             {{:client, {:by_id, _}, ^instance_id}, pid2, _value4}
           ] =
             Registry.select(Untether.Registry, [
               {{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}
             ])
             |> Enum.sort()

    assert Process.alive?(pid1)
    assert Process.alive?(pid2)

    # Cleanup
    :gen_tcp.close(socket1)
    :gen_tcp.close(socket2)
  end
end
