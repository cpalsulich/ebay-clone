defmodule Ebay.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :item_name, :string, null: false
      add :price, :integer, null: false, default: 1
      add :start, :utc_datetime, null: false
      add :finish, :utc_datetime, null: false
      add :started, :boolean, null: false, default: false
      add :finished, :boolean, null: false, default: false
      timestamps()
    end
  end
end
