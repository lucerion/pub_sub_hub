defmodule PubSubHub.Hub.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :callback_url, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :channel_id, references(:channels, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:subscriptions, [:user_id, :channel_id])
  end
end
