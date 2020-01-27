defmodule PubSubHub.Hub.Router do
  @moduledoc "Hub router"

  use Plug.Router

  alias Plug.Conn.Status
  alias PubSubHub.{Hub, Subscribers, Channels}

  plug(Plug.Parsers, parsers: [:urlencoded])

  plug(:match)
  plug(:dispatch)

  post "/subscription" do
    with %{"token" => token, "channel_url" => channel_url, "callback_url" => callback_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by_url(channel_url),
         {:ok, _} <- Hub.subscribe(subscriber, channel, callback_url) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/subscription" do
    with %{"token" => token, "channel_url" => channel_url} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by_token(token),
         channel when not is_nil(channel) <- Channels.find_by_url(channel_url),
         {:ok, _} <- Hub.unsubscribe(subscriber, channel) do
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
