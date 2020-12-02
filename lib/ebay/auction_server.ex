defmodule Ebay.AuctionServer do
  use GenServer
  require Ecto.Query

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
    GenServer.call(pid, {:add, auction})
  end

  def bid(pid, id, amount) do
    GenServer.call(pid, {:bid, [id, amount]})
  end

  @impl true
  def init(_state) do
    auctions = Ebay.Auction |> Ecto.Query.where(finished: false) |> Ebay.Repo.all
    {:ok, Enum.reduce(auctions, %{}, &add_auction/2)}
  end

  @impl true
  def handle_call({:bid, [id, amount]}, _from, state) do
    a = Ebay.Auction.bid(Map.get(state, id), amount)
    {:reply, a, Map.put(state, id, a)}
  end

  @impl true
  def handle_call({:add, auction}, _from, state) do
    {:reply, auction, add_auction(auction, state)}
  end

  @impl true
  def handle_cast({:start, id}, state) do
    {:noreply, Map.put(state, id, Ebay.Auction.start(Map.get(state, id)))}
  end

  @impl true
  def handle_cast({:finish, id}, state) do
    {:noreply, Map.put(state, id, Ebay.Auction.finish(Map.get(state, id)))}
  end

  defp add_auction(auction, map) do
    IO.puts("adding new auction #{auction.id}")
    schedule_start(auction)
    schedule_finish(auction)
    Map.put(map, auction.id, auction)
  end

  defp schedule_start(auction) do
    Scheduler.schedule(Scheduler,
      fn () -> GenServer.cast(Ebay.AuctionServer, {:start, auction.id}) end,
      auction.start |> DateTime.add(5, :millisecond))
  end

  defp schedule_finish(auction) do
    Scheduler.schedule(Scheduler,
      fn () -> GenServer.cast(Ebay.AuctionServer, {:finish, auction.id}) end,
      auction.finish |> DateTime.add(5, :millisecond))
  end


end
