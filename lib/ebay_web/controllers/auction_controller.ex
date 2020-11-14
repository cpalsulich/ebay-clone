defmodule EbayWeb.AuctionController do
  use EbayWeb, :controller
  require IEx

  alias Ebay.Auction

  def index(conn, _params) do
    auctions = Auction.list_auctions()
    render(conn, "index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auction.update_changeset(Auction.new())
    # IEx.pry
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    case Auction.create_auction(auction_params) do
      {:ok, auction} ->
        IO.inspect(auction)
        conn
        |> put_flash(:info, "Auction created successfully.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auction = Auction.get_auction!(id)
    render(conn, "show.html", auction: auction)
  end

  def edit(conn, %{"id" => id}) do
    auction = Auction.get_auction!(id)
    # IEx.pry
    changeset = Auction.update_changeset(auction)
    render(conn, "edit.html", auction: auction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = Auction.get_auction!(id)
    case Auction.update_auction(auction, auction_params) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: Routes.auction_path(conn, :show, auction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", auction: auction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _auction} = Auction.delete_auction(Auction.get_auction!(id))

    conn
    |> put_flash(:info, "Auction deleted successfully.")
    |> redirect(to: Routes.auction_path(conn, :index))
  end
end
