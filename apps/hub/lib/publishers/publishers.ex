defmodule PubSubHub.Hub.Publishers do
  @moduledoc "Publishers related business logic"

  alias PubSubHub.Hub.{Publishers.Publisher, Repo}

  @doc "Fetches publisher by token"
  # @spec find_by_token(String.t()) :: Publisher.t() | nil
  def find_by_token(_token), do: %Publisher{}

  @doc "Creates a publisher"
  @spec create(map) :: {:ok, Publisher.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Publisher{}
    |> Publisher.create_changeset(attributes)
    |> Repo.insert()
  end
end
