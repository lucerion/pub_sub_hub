import Config

config :hub, ecto_repos: [PubSubHub.Hub.Repo]
config :hub, PubSubHub.Hub.Repo, url: System.get_env("DATABASE_URL")

config :hub, rpc_url: System.get_env("HUB_RPC_URL") || "hub@localhost"
config :publisher, rpc_url: System.get_env("PUBLISHER_RPC_URL") || "publisher@localhost"
config :subscriber, rpc_url: System.get_env("SUBSCRIBER_RPC_URL") || "subscriber@localhost"

import_config "#{Mix.env()}.exs"
