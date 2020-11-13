defmodule Ebay.Repo.Migrations.UpdateAuctionsPriceType do
  use Ecto.Migration

  def change do
    execute """
      alter table auctions alter column price type integer using (price::numeric::integer)
      """
  end
end
