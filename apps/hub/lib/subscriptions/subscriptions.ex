defmodule PubSubHub.Hub.Subscriptions do
  @moduledoc "Subscriptions related business logic"

  alias PubSubHub.Hub.{Subscriptions.Subscription, Repo}

  @doc "Creates a subscription"
  @spec create(map) :: {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Subscription{}
    |> Subscription.create_changeset(attributes)
    |> Repo.insert()
  end
end
