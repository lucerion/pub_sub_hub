defmodule PubSubHub.Hub.API.SubscriberEndpoint do
  @moduledoc "Subscriber endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels, Secret}

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
         {:ok, _subscription} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/", private: %{auth: true} do
    with %{"channel_url" => channel_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         {:ok, _subscription} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  defp current_resource(%Plug.Conn{body_params: %{"email" => email}}), do: Subscribers.find_by(%{email: email})
  defp current_resource(%Plug.Conn{private: %{token: token}}), do: Subscribers.find_by(%{token: token})
  defp current_resource(_conn), do: nil
end
