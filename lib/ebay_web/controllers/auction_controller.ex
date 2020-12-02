defmodule EbayWeb.AuctionController do
  use EbayWeb, :controller

  alias Ebay.Auction
  alias Ebay.Bid

  def index(conn, _params) do
    auctions = Auction.get_unfinished()
    render(conn, "index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auction.update_changeset(Auction.new_struct())
    IO.puts(Auction.new_struct().started)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    case Auction.create(auction_params) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction created successfully.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auction = Auction.get!(id)
    if auction.started do
      render(conn, "show.html", auction: auction, bid_changeset: Bid.create_changeset())
    else
      render(conn, "show.html", auction: auction)
    end
  end

  def edit(conn, %{"id" => id}) do
    auction = Auction.get!(id)
    # IEx.pry
    changeset = Auction.update_changeset(auction)
    render(conn, "edit.html", auction: auction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = Auction.get!(id)
    case Auction.update(auction, auction_params) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", auction: auction, changeset: changeset)

      _ ->
        conn
        |> put_flash(:info, "Auction update unsuccessful.")
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _auction} = Auction.delete(Auction.get!(id))

    conn
    |> put_flash(:info, "Auction deleted successfully.")
    |> redirect(to: Routes.auction_path(conn, :index))
  end
end
