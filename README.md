# Ebay

```elixir
a = Ebay.Auction.new()
Ebay.AuctionServer.new_auction(Ebay.AuctionServer, a)
Ebay.AuctionServer.bid(Ebay.AuctionServer, a.id)

Scheduler.schedule(Scheduler, fn () -> IO.puts("testing!!!!") end, DateTime.utc_now() |> DateTime.add(5, :second))
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ebay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ebay, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ebay](https://hexdocs.pm/ebay).

