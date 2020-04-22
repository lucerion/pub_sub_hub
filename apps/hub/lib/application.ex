defmodule PubSubHub.Hub.Application do
  @moduledoc "Hub application"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    %{port: port} = URI.parse(Application.get_env(:hub, :url))

    children = [
      worker(PubSubHub.Hub.Repo, []),
      {Plug.Cowboy, scheme: :http, plug: PubSubHub.Hub.API.RootEndpoint, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: PubSubHub.Hub.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
