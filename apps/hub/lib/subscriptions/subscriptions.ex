defmodule PubSubHub.Hub.Subscriptions do
  @moduledoc "Subscriptions related business logic"

  import Ecto.Query

  alias PubSubHub.Hub.{Subscriptions.Subscription, Repo}

  @doc "Fetches subscription by criteria"
  @spec find_by(map) :: Subscription.t() | nil
  def find_by(%{subscriber_id: subscriber_id, channel_id: channel_id}) do
    Subscription
    |> where(subscriber_id: ^subscriber_id)
    |> by_channel_query(channel_id)
    |> Repo.one()
  end

  def find_by(_attributes), do: nil

  @doc "Fetches subscriptions by criteria"
  def filter(%{channel_id: channel_id}) do
    Subscription
    |> by_channel_query(channel_id)
    |> Repo.all()
  end

  def filter(_attributes), do: []

  @doc "Creates a subscription"
  @spec create(Subscription.attributes()) :: {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Subscription{}
    |> Subscription.changeset(attributes)
    |> Repo.insert()
  end

  @doc "Deletes a subscription"
  @spec delete(Subscription.t()) :: {:ok, Subscription.t()}
  def delete(%Subscription{} = subscription), do: Repo.delete(subscription)

  defp by_channel_query(query, channel_id), do: where(query, channel_id: ^channel_id)
end
