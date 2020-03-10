defmodule PubSubHub.Hub.API.Endpoints.PublisherEndpoint do
  @moduledoc "Publisher endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Publishers, Channels, Secret, Token}

  post "/auth" do
    with %{"email" => email, "secret" => secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{email: email}),
         true <- Secret.verify(publisher, secret),
         {:ok, token} <- Token.refresh(publisher) do
      send_response(conn, :ok, token)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  post "/publish", private: %{auth: true} do
    with %{"channel_url" => channel_url} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token(conn)}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, publisher_id: publisher.id}),
         {:ok, _} <- Hub.broadcast(publisher, channel, "data_from_body") do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
