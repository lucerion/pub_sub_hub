defmodule PubSubHub.Hub.Repo.Migrations.AddChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :url,         :string
      add :secret_hash, :string
      add :secret_salt, :string

      add :publisher_id, references(:publishers, on_delete: :delete_all)

      timestamps()
    end
  end
end
