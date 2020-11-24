defmodule Ebay.Repo.Migrations.BidBelongsToAuction do
  use Ecto.Migration

  def change do
    alter table(:bids) do
      add :auction_id, references(:auctions)
    end
  end
end
