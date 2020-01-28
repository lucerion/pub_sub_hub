defmodule PubSubHub.Hub.Repo.Migrations.AddPublishers do
  use Ecto.Migration

  def change do
    create table(:publishers) do
      add :email,       :string, null: false
      add :secret_hash, :string, null: false
      add :token,       :string

      timestamps()
    end

    create unique_index(:publishers, [:email])
  end
end
