import Config

config :hub, ecto_repos: [PubSubHub.Hub.Repo]
config :hub, PubSubHub.Hub.Repo, url: System.get_env("DATABASE_URL")

config :hub,
  rpc_url: System.get_env("HUB_RPC_URL") || "hub@localhost",
  rpc_supervisor: PubSubHub.Hub.RPC.Supervisor,
  rpc_publisher_module: PubSubHub.Hub.RPC.Publisher,
  rpc_subscriber_module: PubSubHub.Hub.RPC.Subscriber

import_config "#{Mix.env()}.exs"
