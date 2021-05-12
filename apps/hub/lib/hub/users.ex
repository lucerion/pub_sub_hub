defmodule PubSubHub.Hub.Users do
  @moduledoc "Users manipulation functions"

  import Ecto.Query

  alias PubSubHub.Hub.{Users.User, Repo}

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

  @doc "Creates a user"
  @spec create(User.create_attributes()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %User{}
    |> User.create_changeset(attributes)
    |> Repo.insert()
  end
end
