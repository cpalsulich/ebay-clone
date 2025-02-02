# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ebay,
  ecto_repos: [Ebay.Repo]

# Configures the endpoint
config :ebay, EbayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HLZVJqAtitaRxYYrzWgI1Iu1z5nqvu3I2ql25gwIcCHOP0rfSCwxkPx6kKXy7itp",
  render_errors: [view: EbayWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ebay.PubSub,
  live_view: [signing_salt: "Wa9Afgjo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money,
  default_currency: :USD,           # this allows you to do Money.new(100)
  separator: ",",                   # change the default thousands separator for Money.to_string
  delimiter: ".",                   # change the default decimal delimeter for Money.to_string
  symbol: true,                    # don’t display the currency symbol in Money.to_string
  symbol_on_right: false,           # position the symbol
  symbol_space: false,              # add a space between symbol and number
  fractional_unit: true,            # display units after the delimeter
  strip_insignificant_zeros: false  # don’t display the insignificant zeros or the delimeter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
