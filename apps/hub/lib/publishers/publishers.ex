defmodule PubSubHub.Hub.Publishers do
  @moduledoc "Publishers related business logic"

  alias PubSubHub.Hub.{Publishers.Publisher, Repo}

  @doc "Creates a publisher"
  @spec create(map) :: {:ok, Publisher.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Publisher{}
    |> Publisher.create_changeset(attributes)
    |> Repo.insert()
  end
end
