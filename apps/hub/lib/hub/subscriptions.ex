defmodule PubSubHub.Hub.Subscriptions do
  @moduledoc "Subscriptions manipulation functions"

  import Ecto.Query

  alias PubSubHub.Hub.{Subscriptions.Subscription, Channels.Channel, Repo}

  @doc "Fetches subscription by criteria"
  @spec find_by(map) :: Subscription.t() | nil
  def find_by(%{user_id: user_id, channel_id: channel_id}) do
    Subscription
    |> where(user_id: ^user_id)
    |> by_channel_query(channel_id)
    |> Repo.one()
  end

  def find_by(_attributes), do: nil

  @doc "Fetches subscriptions by criteria"
  @spec filter(map) :: list(Subscription.t()) | []
  def filter(%{channel_id: channel_id}) do
    Subscription
    |> by_channel_query(channel_id)
    |> Repo.all()
  end

  def filter(%Channel{id: channel_id}), do: filter(%{channel_id: channel_id})

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
