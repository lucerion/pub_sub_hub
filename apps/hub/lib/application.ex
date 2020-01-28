defmodule PubSubHub.Hub.Application do
  @moduledoc "Hub application"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(PubSubHub.Hub.Repo, []),
      {Plug.Cowboy, scheme: :http, plug: PubSubHub.Hub.Router, options: [port: Application.get_env(:hub, :port)]}
    ]

    opts = [strategy: :one_for_one, name: PubSubHub.Hub.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
