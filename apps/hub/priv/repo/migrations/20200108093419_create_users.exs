defmodule PubSubHub.Hub.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email,          :string, null: false
      add :secret_hash,    :string, null: false
      add :token,          :string
      add :rpc_url,        :string, null: false
      add :rpc_supervisor, :string, null: false
      add :rpc_module,     :string, null: false

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
