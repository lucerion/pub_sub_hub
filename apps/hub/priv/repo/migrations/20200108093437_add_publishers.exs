defmodule PubSubHub.Hub.Repo.Migrations.AddPublishers do
  use Ecto.Migration

  def change do
    create table(:publishers) do
      add :secret_hash, :string
      add :token,       :string

      timestamps()
    end
  end
end
