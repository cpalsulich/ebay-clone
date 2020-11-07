defmodule Ebay.Auction do

  defstruct [
    id: UUID.uuid4(),
    item_name: "value",
    price: 0,
    start: DateTime.utc_now() |> DateTime.add(10, :second),
    finish: DateTime.utc_now() |> DateTime.add(30, :second),
    started: false,
    finished: false
  ]

  def new() do
    %__MODULE__{
      id: UUID.uuid4(),
      start: DateTime.utc_now() |> DateTime.add(1, :second),
      finish: DateTime.utc_now() |> DateTime.add(5, :second),
    }
  end

  def new(item_name, price, start, finish) do
    %__MODULE__{
      id: UUID.uuid4(),
      item_name: item_name,
      price: price,
      start: start,
      finish: finish
    }
  end

  def start(auction) do
    id = auction.id
    if DateTime.compare(DateTime.now!(auction.start.time_zone), auction.start) == :lt do
      IO.puts("auction #{id} started too early")
      auction
    else
      IO.puts("auction #{id} started")
      %__MODULE__{auction | started: true }
    end
  end

  def finish(auction) do
    id = auction.id
    if DateTime.compare(DateTime.now!(auction.finish.time_zone), auction.finish) == :lt do
      IO.puts("auction #{id} finished too early")
      auction
    else
      IO.puts("auction #{id} finished")
      %__MODULE__{auction | finished: true }
    end
  end

  def bid(auction = %__MODULE{finished: true}) do
    IO.puts("auction finished")
    auction
  end

  def bid(auction = %__MODULE{started: false}) do
    IO.puts("auction not started")
    auction
  end

  def bid(auction) do
    IO.puts("bidding on auction #{auction.id}, price: #{auction.price}")
    %__MODULE__{auction | price: auction.price + 1}
  end
end
