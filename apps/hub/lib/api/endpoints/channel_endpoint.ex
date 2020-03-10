defmodule PubSubHub.Hub.API.Endpoints.ChannelEndpoint do
  @moduledoc "Channel endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Channels, Publishers}

  post "/", private: %{auth: true} do
    with %{"url" => url, "channel_secret" => channel_secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token(conn)}),
         {:ok, channel} when not is_nil(channel) <-
           Channels.create(%{url: url, secret: channel_secret, publisher_id: publisher.id}) do
      send_response(conn, :ok, url)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/", private: %{auth: true} do
    with %{"url" => url} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token(conn)}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: url, publisher_id: publisher.id}),
         {:ok, _} <- Channels.delete(channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
