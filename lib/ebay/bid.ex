defmodule Ebay.Bid do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "bids" do
    field :price, Money.Ecto.Amount.Type
    belongs_to :auction, Ebay.Auction
    timestamps()
  end

  def create(auction, price) do
    Ebay.Repo.insert(Ecto.build_assoc(auction, :bids, %{price: price}))
  end

  def new_struct(auction_id, price) do
    %__MODULE__{
      auction_id: auction_id,
      price: price
    }
  end

  def create_changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:price])
    |> validate_required([:price])
  end
end
