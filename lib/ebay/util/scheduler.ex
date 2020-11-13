defmodule Scheduler do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def child_spec(name) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]}
    }
  end

  def schedule(pid, work, datetime) do
    d = DateTime.diff(datetime, DateTime.now!(datetime.time_zone), :millisecond)
    IO.puts("diff is #{d}")
    delta = if (d < 0), do: 0, else: d
    IO.puts("calling function in #{delta}ms")
    id = UUID.uuid4(:hex)
    GenServer.cast(pid, {:work, {id, work}})
    Process.send_after(
      pid,
      id,
      delta)
  end

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_info(id, state) do
    Map.get(state, id).()
    {:noreply, Map.delete(state, id)}
  end

  @impl true
  def handle_cast({:work, {id, work}}, state) do
    {:noreply, Map.put(state, id, work)}
  end
end
