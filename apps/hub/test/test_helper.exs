Application.ensure_all_started(:bypass)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(PubSubHub.Hub.Repo, :manual)
