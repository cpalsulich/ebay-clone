defmodule Ebay.AuctionServer do
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

  # client code
  def new_auction(pid, auction) do
    GenServer.call(pid, {:create, auction})
  end

  def bid(pid, id) do
    GenServer.call(pid, {:bid, id})
  end

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:bid, id}, _from, state) do
    a = Ebay.Auction.bid(Map.get(state, id))
    {:reply, a, Map.put(state, id, a)}
  end

  @impl true
  def handle_call({:create, auction}, _from, state) do
    IO.puts("adding new auction #{auction.id}")
    Scheduler.schedule(Scheduler,
      fn () -> GenServer.cast(Ebay.AuctionServer, {:start, auction.id}) end,
      auction.start |> DateTime.add(5, :millisecond))
    Scheduler.schedule(Scheduler,
      fn () -> GenServer.cast(Ebay.AuctionServer, {:finish, auction.id}) end,
      auction.finish |> DateTime.add(5, :millisecond))
    {:reply, auction, Map.put(state, auction.id, auction)}
  end

  @impl true
  def handle_cast({:start, id}, state) do
    {:noreply, Map.put(state, id, Ebay.Auction.start(Map.get(state, id)))}
  end

  @impl true
  def handle_cast({:finish, id}, state) do
    {:noreply, Map.put(state, id, Ebay.Auction.finish(Map.get(state, id)))}
  end


end
