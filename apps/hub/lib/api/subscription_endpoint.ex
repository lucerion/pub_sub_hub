defmodule PubSubHub.Hub.API.SubscriptionEndpoint do
  @moduledoc "Subscription endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels, Secret}

  post "/" do
    with %{
           "token" => token,
           "callback_url" => callback_url,
           "channel_url" => channel_url,
           "channel_secret" => channel_secret
         } <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/" do
    with %{"token" => token, "channel_url" => channel_url, "channel_secret" => channel_secret} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
