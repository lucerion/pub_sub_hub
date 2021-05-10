defmodule PubSubHub.Hub.API.SubscriberEndpoint do
  @moduledoc "Subscriber endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Channels, Subscriptions, Secret}

  post "/auth" do
    conn
    |> current_resource()
    |> auth(conn)
  end

  post "/", private: %{auth: true} do
    with %{
           "callback_url" => callback_url,
           "channel_url" => channel_url,
           "channel_secret" => channel_secret
         } <- conn.body_params,
         subscriber when not is_nil(subscriber) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         true <- Secret.verify(channel, channel_secret),
         {:ok, _subscription} <-
           Subscriptions.create(%{user_id: subscriber.id, channel_id: channel.id, callback_url: callback_url}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/", private: %{auth: true} do
    with %{"channel_url" => channel_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         subscription when not is_nil(subscription) <-
           Subscriptions.find_by(%{user_id: subscriber.id, channel_id: channel.id}),
         {:ok, _subscription} <- Subscriptions.delete(subscription) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
