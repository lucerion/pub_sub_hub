defmodule PubSubHub.Hub.RPC.Subscriber do
  @moduledoc "Subscriber RPC functions"

  use PubSubHub.Hub.RPC

  alias PubSubHub.Hub.{Users, Channels, Subscriptions, Secret, Token}

  @doc "Subscribes Subscriber to a channel"
  @spec subscribe(%{
          token: Token.t(),
          channel_name: String.t(),
          channel_secret: Secret.t(),
          callback_url: String.t()
        }) :: term
  def subscribe(%{token: token, channel_name: channel_name, channel_secret: channel_secret}) do
    with subscriber when not is_nil(subscriber) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{name: channel_name}),
         true <- Secret.verify(channel, channel_secret) do
      %{user_id: subscriber.id, channel_id: channel.id, callback_url: @subscriber.url}
      |> Subscriptions.create()
      |> send_response()
    end
  end

  @doc "Unsubscribes Subscriber from a channel"
  @spec unsubscribe(%{token: Token.t(), channel_name: String.t()}) :: term
  def unsubscribe(%{token: token, channel_name: channel_name}) do
    with subscriber when not is_nil(subscriber) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{name: channel_name}) do
      %{user_id: subscriber.id, channel_id: channel.id}
      |> Subscriptions.find_by()
      |> Subscriptions.delete()
      |> send_response()
    end
  end

  defp send_response(response), do: send_response(response, @subscriber)
end
