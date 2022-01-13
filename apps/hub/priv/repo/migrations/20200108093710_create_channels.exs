defmodule PubSubHub.Hub.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name,        :string, null: false
      add :secret_hash, :string, null: false

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:channels, [:name, :user_id])
  end
end
