defmodule EbayWeb.AuctionControllerTest do
  use EbayWeb.ConnCase

  alias Ebay.Auction

  @create_attrs %{finish: DateTime.utc_now() |> DateTime.add(5, :second) |> DateTime.to_string(),
    item_name: "some item_name",
    price: 42,
    start: DateTime.utc_now() |> DateTime.add(3, :second) |> DateTime.to_string()}
  @update_attrs %{finish: DateTime.utc_now() |> DateTime.add(5, :second) |> DateTime.to_string(),
    item_name: "some updated item_name",
    price: 43,
    start: DateTime.utc_now() |> DateTime.add(3, :second) |> DateTime.to_string()}
  @invalid_attrs %{finish: nil, finished: nil, item_name: nil, price: nil, start: nil, started: nil}

  def fixture(:auction) do
    {:ok, auction} = Auction.create_auction(@create_attrs)
    auction
  end

  describe "index" do
    test "lists all auctions", %{conn: conn} do
      conn = get(conn, Routes.auction_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Auctions"
    end
  end

  describe "new auction" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.auction_path(conn, :new))
      assert html_response(conn, 200) =~ "New Auction"
    end
  end

  describe "create auction" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.auction_path(conn, :create), auction: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.auction_path(conn, :show, id)

      conn = get(conn, Routes.auction_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Auction"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.auction_path(conn, :create), auction: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Auction"
    end
  end

  describe "edit auction" do
    setup [:create_auction]

    test "renders form for editing chosen auction", %{conn: conn, auction: auction} do
      conn = get(conn, Routes.auction_path(conn, :edit, auction))
      assert html_response(conn, 200) =~ "Edit Auction"
    end
  end

  describe "update auction" do
    setup [:create_auction]

    test "redirects when data is valid", %{conn: conn, auction: auction} do
      conn = put(conn, Routes.auction_path(conn, :update, auction), auction: @update_attrs)
      assert redirected_to(conn) == Routes.auction_path(conn, :show, auction)

      conn = get(conn, Routes.auction_path(conn, :show, auction))
      assert html_response(conn, 200) =~ "some updated item_name"
    end

    test "renders errors when data is invalid", %{conn: conn, auction: auction} do
      conn = put(conn, Routes.auction_path(conn, :update, auction), auction: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Auction"
    end
  end

  describe "delete auction" do
    setup [:create_auction]

    test "deletes chosen auction", %{conn: conn, auction: auction} do
      conn = delete(conn, Routes.auction_path(conn, :delete, auction))
      assert redirected_to(conn) == Routes.auction_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.auction_path(conn, :show, auction))
      end
    end
  end

  defp create_auction(_) do
    auction = fixture(:auction)
    %{auction: auction}
  end
end
