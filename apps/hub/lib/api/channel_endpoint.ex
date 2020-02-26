defmodule PubSubHub.Hub.API.ChannelEndpoint do
  @moduledoc "Channel endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Channels, Publishers}

  post "/" do
    with %{"token" => token, "url" => url, "secret" => secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token}),
         {:ok, channel} when not is_nil(channel) <-
           Channels.create(%{url: url, secret: secret, publisher_id: publisher.id}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/" do
    with %{"token" => token, "url" => url} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: url, publisher_id: publisher.id}),
         {:ok, _} <- Channels.delete(channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
