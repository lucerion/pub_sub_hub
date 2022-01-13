defmodule PubSubHub.Hub.Users do
  @moduledoc "Users manipulation functions"

  import Ecto.Query

  alias PubSubHub.Hub.{Users.User, Repo, Secret}

  @doc "Fetches user by criteria"
  @spec find_by(map) :: User.t() | nil
  def find_by(%{token: token}) do
    User
    |> where(token: ^token)
    |> Repo.one()
  end

  def find_by(%{email: email}) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc "Creates an user"
  @spec create(User.create_attributes()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %User{}
    |> User.create_changeset(attributes)
    |> Secret.hash_secret()
    |> Repo.insert()
  end

  @doc "Updates an user"
  @spec update(User.t(), User.update_attributes()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update(%User{} = user, attributes) do
    user
    |> User.update_changeset(attributes)
    |> Repo.update()
  end
end
