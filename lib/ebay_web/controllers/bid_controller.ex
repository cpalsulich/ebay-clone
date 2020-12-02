defmodule EbayWeb.BidController do
  use EbayWeb, :controller

  alias Ebay.Bid
  alias Ebay.Auction

  def create(conn, %{"auction_id" => auction_id, "bid" => params}) do
    # it's possible to bid on finished auctions
    auction = Auction.get!(auction_id)
    price = Money.parse!(Map.get(params, "price"))
    IO.puts(price)
    case Bid.create(auction, price) do
      {:ok, _bid} ->
        conn
        |> put_flash(:info, "Bid successful.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      {:error, changeset} ->
        IO.puts(changeset)
        conn
        |> put_flash(:info, "Bid unsuccessful.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      _ ->
        conn
        |> put_flash(:info, "Bid unsuccessful.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))
    end
  end
end
