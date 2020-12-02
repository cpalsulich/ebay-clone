defmodule Ebay.Repo.Migrations.UpdateBidsPriceNotNull do
  use Ecto.Migration

  def change do
    execute """
      alter table bids alter column price set not null
    """
  end
end
