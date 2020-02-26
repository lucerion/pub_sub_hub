defmodule PubSubHub.Hub do
  @moduledoc """
  Service that subscribes/unsubscribes Subscribers to Publisher channels and sends Publishers data to the Subscribers
  """

  alias PubSubHub.Hub.{
    Subscribers.Subscriber,
    Channels.Channel,
    Subscriptions.Subscription,
    Subscriptions
  }

  @doc "Subscribe to a channel"
  @spec subscribe(%Subscriber{id: Subscriber.id() | nil}, %Channel{id: Channel.id() | nil}, String.t()) ::
          {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}
  def subscribe(%Subscriber{id: subscriber_id}, %Channel{id: channel_id}, callback_url),
    do: Subscriptions.create(%{subscriber_id: subscriber_id, channel_id: channel_id, callback_url: callback_url})

  @doc "Unsubscriber from a channel"
  def unsubscribe(_subscriber, _channel), do: {:ok, nil}
end
