defmodule Ebay.Bid do
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  schema "bids" do
    field :price, Money.Ecto.Amount.Type
    belongs_to :auction, Ebay.Auction
    timestamps()
  end
end
