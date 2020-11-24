defmodule EbayWeb.AuctionView do
  use EbayWeb, :view

  def current_bid(auction) do
    Ebay.Auction.current_bid(auction)
  end
end
