import Config

config :ebay,
  ecto_repos: [Ebay.Repo]

config :ebay, Ebay.Repo,
  database: "ebay_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
