defmodule PubSubHub.Hub.Repo.Migrations.AddSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :secret_hash, :string
      add :token,       :string

      timestamps()
    end
  end
end
