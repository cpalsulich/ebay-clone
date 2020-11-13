defmodule Ebay.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :item_name, :string
    field :price, Money.Ecto.Amount.Type
    field :start, :utc_datetime
    field :finish, :utc_datetime
    field :started, :boolean
    field :finished, :boolean
  end

  def new() do
    new("test_item",
      Money.new(0),
      DateTime.utc_now() |> DateTime.add(1, :second),
      DateTime.utc_now() |> DateTime.add(5, :second))
  end

  def new(item_name, price, start, finish) do
    Ebay.Repo.insert!(create_changeset(%__MODULE__{
      item_name: item_name,
      price: price,
      start: start |> DateTime.truncate(:second),
      finish: finish |> DateTime.truncate(:second)
    }))
  end

  def start(auction) do
    changeset = Ebay.Auction.started_changeset(auction, %{started: true})
    Ebay.Repo.update!(changeset)
  end

  def finish(auction) do
    changeset = Ebay.Auction.finished_changeset(auction, %{finished: true})
    Ebay.Repo.update!(changeset)
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
    changeset = Ebay.Auction.price_changeset(auction, %{price: Money.add(auction.price, Money.new(100))})
    Ebay.Repo.update!(changeset)
  end

  def started_changeset(auction, params \\ %{}) do
    auction
    |> cast(params, [:started])
    |> validate_acceptance(:started)
    |> validate_change(:started,
      fn :started, _started ->
        if DateTime.compare(DateTime.now!(auction.start.time_zone), auction.start) == :lt do
          [started: "auction started too early"]
        else
          []
        end
      end
    )
  end

  def finished_changeset(auction, params \\ %{}) do
    auction
    |> cast(params, [:finished])
    |> validate_acceptance(:finished)
    |> validate_change(:finished,
      fn :finished, _finished ->
        if DateTime.compare(DateTime.now!(auction.finish.time_zone), auction.finish) == :lt do
          [finished: "auction finished too early"]
        else
          []
        end
      end
    )
  end

  def price_changeset(auction, params \\ %{}) do
    auction
    |> cast(params, [:price])
    |> validate_change(:price,
      fn :price, price ->
        if price <= auction.price || auction.finished || !auction.started do
          [price: "must be greater than previous price and auction must be live"]
        else
          []
        end
      end)
  end

  def create_changeset(auction, params \\ %{}) do
    auction
    |> cast(params, [:item_name, :price, :start, :finish])
    |> validate_required([:item_name, :price, :start, :finish])
    |> validate_item_name()
    |> validate_price()
    |> validate_start()
    |> validate_finish()
    |> validate_start_finish()
  end

  defp validate_item_name(changeset) do
    validate_change(changeset, :item_name, fn :item_name, name ->
      if String.length(name) < 4 do
        [item_name: "can't be empty and must be at least 4 characters"]
      else
        []
      end
    end)
  end

  defp validate_price(changeset) do
    validate_change(changeset, :price, fn :price, price ->
      if !is_number(price) do
        [price: "can't be empty and must be a number"]
      else
        []
      end
    end)
  end

  defp validate_start(changeset) do
    validate_change(changeset, :start, fn :start, start ->
      if DateTime.compare(DateTime.now!(start.time_zone), start) != :lt do
        [start: "must be in the future"]
      end
    end)
  end

  defp validate_finish(changeset) do
    validate_change(changeset, :finish, fn :finish, finish ->
      if DateTime.compare(DateTime.now!(finish.time_zone), finish) != :lt do
        [finish: "must be in the future"]
      else
        []
      end
    end)
  end

  defp validate_start_finish(changeset) do
    start = get_field(changeset, :start)
    finish = get_field(changeset, :finish)

    if DateTime.compare(start, finish) != :lt do
      add_error(changeset, :finish, "should be after start")
    else
      changeset
    end
  end
end
