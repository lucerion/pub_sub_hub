defmodule PubSubHub.Hub.API.Endpoints.SubscriptionEndpoint do
  @moduledoc "Subscription endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels, Secret}

  post "/" do
    with %{
           "callback_url" => callback_url,
           "channel_url" => channel_url,
           "channel_secret" => channel_secret
         } <- conn.body_params,
         token when not is_nil(token) <- token(conn),
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/" do
    with %{"channel_url" => channel_url, "channel_secret" => channel_secret} <- conn.body_params,
         token when not is_nil(token) <- token(conn),
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
