defmodule PubSubHub.Hub.Subscribers do
  @moduledoc "Subscribers related business logic"

  alias PubSubHub.Hub.{Subscribers.Subscriber, Repo}

  @doc "Fetches subscriber by token"
  @spec find_by_token(String.t()) :: Subscriber.t() | nil
  def find_by_token(_token), do: %Subscriber{}

  @doc "Creates a subscriber"
  def create(attributes) do
    %Subscriber{}
    |> Subscriber.create_changeset(attributes)
    |> Repo.insert()
  end
end
