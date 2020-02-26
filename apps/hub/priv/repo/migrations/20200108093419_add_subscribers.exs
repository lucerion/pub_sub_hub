defmodule PubSubHub.Hub.Repo.Migrations.AddSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email,       :string, null: false
      add :secret_hash, :string, null: false
      add :token,       :string

      timestamps()
    end

    create unique_index(:subscribers, :email)
  end
end
