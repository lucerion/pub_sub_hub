defmodule PubSubHub.Hub.Subscribers do
  @moduledoc "Subscribers related business logic"

  alias PubSubHub.Hub.{Subscribers.Subscriber, Repo, Secret}

  @doc "Fetches subscriber by token"
  @spec find_by_token(String.t()) :: Subscriber.t() | nil
  def find_by_token(_token), do: %Subscriber{}

  def create(%{secret: secret}) do
    %Subscriber{}
    |> Subscriber.create_changeset(%{secret: secret})
    |> Repo.insert()
  end

  def create, do: create(%{secret: Secret.generate()})
end
