defmodule EbayWeb.AuctionView do
  use EbayWeb, :view


  def current_bid(auction) do
    Money.to_string(Ebay.Auction.current_bid(auction))
  end
end
