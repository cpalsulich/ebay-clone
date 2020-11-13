defmodule Ebay.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :item_name, :string, null: false
      add :price, :integer, null: false
      add :start, :utc_datetime, null: false
      add :finish, :utc_datetime, null: false
      add :started, :boolean, default: false, null: false
      add :finished, :boolean, default: false, null: false
    end
  end
end
