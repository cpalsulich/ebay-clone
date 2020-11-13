import Config

config :ebay, ecto_repos: [Ebay.Repo]

config :ebay, Ebay.Repo,
  database: "ebay_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :money,
  default_currency: :USD,           # this allows you to do Money.new(100)
  separator: ",",                   # change the default thousands separator for Money.to_string
  delimiter: ".",                   # change the default decimal delimeter for Money.to_string
  symbol: false,                     # don’t display the currency symbol in Money.to_string
  symbol_on_right: false,           # position the symbol
  symbol_space: false,               # add a space between symbol and number
  fractional_unit: true,             # display units after the delimeter
  strip_insignificant_zeros: false  # don’t display the insignificant zeros or the delimeter
