defmodule PubSubHub.Hub.API.SubscriberEndpoint do
  @moduledoc "Subscriber endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels, Secret, Token}

  post "/auth" do
    with %{"email" => email, "secret" => secret} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{email: email}),
         true <- Secret.verify(subscriber, secret),
         {:ok, token} <- Token.refresh(subscriber) do
      send_response(conn, :ok, token)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  post "/", private: %{auth: true} do
    with %{
           "callback_url" => callback_url,
           "channel_url" => channel_url,
           "channel_secret" => channel_secret
         } <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token(conn)}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/", private: %{auth: true} do
    with %{"channel_url" => channel_url, "channel_secret" => channel_secret} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{token: token(conn)}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
