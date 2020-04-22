defmodule PubSubHub.Publisher.Application do
  @moduledoc "Publisher application"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      {Task.Supervisor, name: PubSubHub.Publisher.RPC.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: PubSubHub.Publisher.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
