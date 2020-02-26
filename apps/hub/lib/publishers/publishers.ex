defmodule PubSubHub.Hub.Publishers do
  @moduledoc "Publishers related business logic"

  import Ecto.Query

  alias PubSubHub.Hub.{Publishers.Publisher, Repo}

  @doc "Fetches publisher by criteria"
  @spec find_by(map) :: Publisher.t() | nil
  def find_by(%{token: token}) do
    Publisher
    |> where(token: ^token)
    |> Repo.one()
  end

  def find_by(%{email: email}) do
    Publisher
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc "Creates a publisher"
  @spec create(Publisher.create_attributes()) :: {:ok, Publisher.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Publisher{}
    |> Publisher.create_changeset(attributes)
    |> Repo.insert()
  end
end
