defmodule PubSubHub.Hub.API.SubscriptionEndpoint do
  @moduledoc "Subscription endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels}

  post "/" do
    with %{"token" => token, "channel_url" => channel_url, "callback_url" => callback_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         {:ok, _} <- Hub.subscribe(subscriber, channel, %{callback_url: callback_url}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/" do
    with %{"token" => token, "channel_url" => channel_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
