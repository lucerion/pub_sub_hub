import Config

config :hub, ecto_repos: [PubSubHub.Hub.Repo]
config :hub, PubSubHub.Hub.Repo, url: System.get_env("DATABASE_URL")
config :hub, url: System.get_env("HUB_URL") || "http://localhost:3000"

import_config "#{Mix.env()}.exs"
