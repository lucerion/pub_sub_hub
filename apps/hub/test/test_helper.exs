Application.ensure_all_started(:bypass)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Reedly.Database.Repo, :manual)
