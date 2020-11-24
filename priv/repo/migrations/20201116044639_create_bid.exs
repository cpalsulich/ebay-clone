defmodule Ebay.Repo.Migrations.CreateBid do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :price, :integer
    end
  end
end
