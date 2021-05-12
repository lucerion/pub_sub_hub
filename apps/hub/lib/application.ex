defmodule PubSubHub.Hub.Application do
  @moduledoc "Hub application"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(PubSubHub.Hub.Repo, []),
      {Task.Supervisor, name: PubSubHub.Hub.RPC.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: PubSubHub.Hub.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
