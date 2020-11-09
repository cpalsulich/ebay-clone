defmodule Ebay.Repo do
  use Ecto.Repo,
    otp_app: :ebay,
    adapter: Ecto.Adapters.Postgres
end
