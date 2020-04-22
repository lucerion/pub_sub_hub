defmodule PubSubHub.Subscriber.Application do
  @moduledoc "Subscriber application"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      {Task.Supervisor, name: PubSubHub.Subscriber.RPC.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: PubSubHub.Subscriber.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
