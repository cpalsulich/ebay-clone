start = DateTime.utc_now() |> DateTime.add(1, :second)
finish = start |> DateTime.add(60, :second)
a = Ebay.Auction.new("new item", 0, start, finish)
Ebay.AuctionServer.new_auction(Ebay.AuctionServer, a)
Scheduler.schedule(Scheduler,
  Ebay.AuctionServer.bid(Ebay.AuctionServer, a.id),
  start |> DateTime.add(500, :millisecond))
