defmodule PubSubHub.Hub.Subscribers do
  @moduledoc "Subscribers related business logic"

  alias PubSubHub.Hub.{Subscribers.Subscriber, Repo}

  @doc "Fetches subscriber by token"
  def find_by_token(_token), do: %Subscriber{}

  @doc "Creates a subscriber"
  @spec create(Subscriber.create_attributes()) :: {:ok, Subscriber.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Subscriber{}
    |> Subscriber.create_changeset(attributes)
    |> Repo.insert()
  end
end
