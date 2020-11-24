defmodule Ebay.Repo.Migrations.BidTimestamps do
  use Ecto.Migration

  def change do
    alter table(:bids) do
      timestamps()
    end
  end
end
