defmodule PubSubHub.Hub do
  @moduledoc """
  Service that subscribes/unsubscribes Subscribers to Publisher channels and sends Publishers data to the Subscribers
  """

  alias PubSubHub.Hub.{
    Subscribers.Subscriber,
    Channels.Channel,
    Subscriptions,
    Subscriptions.Subscription
  }

  @doc "Subscribe to a channel"
  @spec subscribe(%Subscriber{id: Subscriber.id() | nil}, %Channel{id: Channel.id() | nil}, String.t()) ::
          {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}
  def subscribe(%Subscriber{id: subscriber_id}, %Channel{id: channel_id}, callback_url),
    do: Subscriptions.create(%{subscriber_id: subscriber_id, channel_id: channel_id, callback_url: callback_url})

  @doc "Unsubscriber from a channel"
  @spec unsubscribe(Subscriber.t(), Channel.t()) :: {:ok, Subscription.t()}
  def unsubscribe(%Subscriber{id: subscriber_id}, %Channel{id: channel_id}) do
    %{subscriber_id: subscriber_id, channel_id: channel_id}
    |> Subscriptions.find_by()
    |> Subscriptions.delete()
  end

  @doc "Broadcasts Publishers data to Subscribers"
  def broadcast(_publisher, _channel, _data), do: {:ok, nil}
end
