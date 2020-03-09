defmodule PubSubHub.Hub.Subscriptions do
  @moduledoc "Subscriptions related business logic"

  import Ecto.Query

  alias PubSubHub.Hub.{Subscriptions.Subscription, Repo}

  @doc "Fetches subscription by criteria"
  @spec find_by(map) :: Subscription.t() | nil
  def find_by(%{subscriber_id: subscriber_id, channel_id: channel_id}) do
    Subscription
    |> where(subscriber_id: ^subscriber_id)
    |> where(channel_id: ^channel_id)
    |> Repo.one()
  end

  @doc "Creates a subscription"
  @spec create(Subscription.create_attributes()) :: {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Subscription{}
    |> Subscription.create_changeset(attributes)
    |> Repo.insert()
  end

  @doc "Deletes a subscription"
  @spec delete(Subscription.t()) :: {:ok, Subscription.t()}
  def delete(%Subscription{} = subscription), do: Repo.delete(subscription)
end
