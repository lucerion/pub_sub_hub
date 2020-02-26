defmodule PubSubHub.Hub.Repo.Migrations.AddSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :callback_url, :string, null: false
      add :subscriber_id, references(:subscribers, on_delete: :delete_all)
      add :channel_id, references(:channels, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:subscriptions, [:subscriber_id, :channel_id])
  end
end
