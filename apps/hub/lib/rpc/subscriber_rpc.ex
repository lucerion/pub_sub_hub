defmodule PubSubHub.Hub.RPC.SubscriberRPC do
  @moduledoc "Subscriber RPC functions"

  use PubSubHub.Hub.RPC

  @repo PubSubHub.Hub.Subscribers

  alias PubSubHub.Hub.{Subscribers, Channels, Subscriptions, Secret, Token}

  @doc "Authenticate Subscriber"
  @spec auth(%{email: String.t(), secret: Secret.t()}) :: term
  def auth(params), do: auth(@subscriber, @repo, params)

  @doc "Subscribes Subscriber to a channel"
  @spec subscribe(%{
          token: Token.t(),
          channel_url: String.t(),
          channel_secret: Secret.t(),
          callback_url: String.t()
        }) :: term
  def subscribe(%{token: token, channel_url: channel_url, channel_secret: channel_secret}) do
    with subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret) do
      %{subscriber_id: subscriber.id, channel_id: channel.id, callback_url: @subscriber.url}
      |> Subscriptions.create()
      |> send_response(@subscriber)
    end
  end

  @doc "Unsubscribes Subscriber from a channel"
  @spec unsubscribe(%{token: Token.t(), channel_url: String.t()}) :: term
  def unsubscribe(%{token: token, channel_url: channel_url}) do
    with subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}) do
      %{subscriber_id: subscriber.id, channel_id: channel.id}
      |> Subscriptions.find_by()
      |> Subscriptions.delete()
      |> send_response(@subscriber)
    end
  end
end
