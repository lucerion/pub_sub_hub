import Config

config :hub, ecto_repos: [PubSubHub.Hub.Repo]
config :hub, PubSubHub.Hub.Repo, url: System.get_env("DATABASE_URL")
config :hub, port: String.to_integer(System.get_env("HUB_PORT") || "3000")

import_config "#{Mix.env()}.exs"
