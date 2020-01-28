defmodule PubSubHub.Hub.Repo.Migrations.AddChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :url,         :string, null: false
      add :secret_hash, :string, null: false

      add :publisher_id, references(:publishers, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:channels, [:url, :publisher_id])
  end
end
