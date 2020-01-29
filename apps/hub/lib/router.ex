defmodule PubSubHub.Hub.Router do
  @moduledoc "Hub router"

  use Plug.Router

  alias Plug.Conn.Status
  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Channels, Publishers}

  plug(Plug.Parsers, parsers: [:urlencoded])

  plug(:match)
  plug(:dispatch)

  post "/subscription" do
    with %{"token" => token, "channel_url" => channel_url, "callback_url" => callback_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         {:ok, _} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/subscription" do
    with %{"token" => token, "channel_url" => channel_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url}),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  post "/channel" do
    with %{"token" => token, "url" => url, "secret" => secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by_token(token),
         {:ok, channel} when not is_nil(channel) <-
           Channels.create(%{url: url, secret: secret, publisher_id: publisher.id}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/channel" do
    with %{"token" => token, "url" => url} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by(%{url: url, publisher_id: publisher.id}),
         {:ok, _} <- Channels.delete(channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  match _ do
    send_response(conn, :not_found)
  end

  defp send_response(conn, reason) do
    status_code = Status.code(reason)
    reason_phrase = Status.reason_phrase(status_code)

    send_resp(conn, status_code, reason_phrase)
  end
end
