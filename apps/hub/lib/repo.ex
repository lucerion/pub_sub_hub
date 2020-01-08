defmodule PubSubHub.Hub.Repo do
  use Ecto.Repo,
    adapter: Ecto.Adapters.Postgres,
    otp_app: :hub
end
