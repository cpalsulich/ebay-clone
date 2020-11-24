defmodule Ebay.Auction do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  @timestamps_opts [type: :utc_datetime]

  schema "auctions" do
    field :item_name, :string
    field :start, :utc_datetime
    field :finish, :utc_datetime
    field :started, :boolean
    field :finished, :boolean
    has_many :bids, Ebay.Bid

    timestamps()
  end

  def new_struct() do
    new_struct("test_item",
      DateTime.utc_now() |> DateTime.add(120, :second),
      DateTime.utc_now() |> DateTime.add(3600 * 24 * 2, :second))
  end

  def new_struct(item_name, start, finish) do
    %__MODULE__{
      item_name: item_name,
      start: start |> DateTime.truncate(:second),
      finish: finish |> DateTime.truncate(:second)
    }
  end

  def create(auction_params) do
    IO.puts("create")
    IO.inspect(auction_params)
    Ebay.Repo.insert(update_changeset(%__MODULE__{}, auction_params))
    |> Ebay.Repo.preload(:bids)
  end

  def update(auction, params) do
    Ebay.Repo.update(update_changeset(auction, params)) |> Ebay.Repo.preload(:bids)
  end

  def get!(id) do
    Ebay.Auction |> Ebay.Repo.get!(id) |> Ebay.Repo.preload(:bids)
  end

  def delete(auction) do
    Ebay.Repo.delete(auction)
  end

  def get_unfinished() do
    Ebay.Auction
    |> Ecto.Query.where(finished: false)
    |> Ebay.Repo.all
    |> Ebay.Repo.preload([bids: Ecto.Query.from(b in Ebay.Bid, order_by: b.price)])
  end

  def start(auction) do
    changeset = Ebay.Auction.started_changeset(auction, %{started: true})
    Ebay.Repo.update!(changeset)
  end

  def finish(auction) do
    changeset = Ebay.Auction.finished_changeset(auction, %{finished: true})
    Ebay.Repo.update!(changeset)
  end

  def current_bid(%__MODULE__{bids: []}) do
    Money.new(0)
  end

  def current_bid(%__MODULE__{bids: [current | _tail]}) do
    current.price
  end

  def bid(auction = %__MODULE{finished: true}, _amount) do
    IO.puts("auction finished")
    auction
  end

  def bid(auction = %__MODULE{started: false}, _amount) do
    IO.puts("auction not started")
    auction
  end

  def bid(auction, amount) do
    _bid = Ebay.Repo.insert!(Ecto.build_assoc(auction, :bids, %{price: amount}))
    auction |> Ebay.Repo.preload(:bids)
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

  def update_changeset(auction, params \\ %{}) do
    auction
    |> cast(params, [:item_name, :start, :finish])
    |> validate_required([:item_name, :start, :finish])
    |> validate_item_name()
    |> validate_start(auction)
    |> validate_finish(auction)
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

  defp validate_start(changeset, auction) do
    validate_change(changeset, :start, fn :start, start ->
      if start == nil
        || (auction.start != nil
          && DateTime.compare(start, auction.start) != :eq
          && DateTime.compare(DateTime.now!(start.time_zone), start) != :lt) do
        [start: "must be in the future"]
      else
        []
      end
    end)
  end

  defp validate_finish(changeset, auction) do
    validate_change(changeset, :finish, fn :finish, finish ->
      if finish == nil
        || (auction.finish != nil
          && DateTime.compare(finish, auction.finish) != :eq
          && DateTime.compare(DateTime.now!(finish.time_zone), finish) != :lt) do
        [finish: "must be in the future"]
      else
        []
      end
    end)
  end

  defp validate_start_finish(changeset) do
    start = get_field(changeset, :start)
    finish = get_field(changeset, :finish)

    if start == nil || finish == nil || DateTime.compare(start, finish) != :lt do
      add_error(changeset, :finish, "should be after start")
    else
      changeset
    end
  end
end
