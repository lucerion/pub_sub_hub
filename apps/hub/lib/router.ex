defmodule PubSubHub.Hub.Router do
  @moduledoc "Hub router"

  use Plug.Router

  alias Plug.Conn.Status
  alias PubSubHub.Hub

  plug(Plug.Parsers, parsers: [:urlencoded])

  plug(:match)
  plug(:dispatch)

  post "/subscribe" do
    with %{"channel" => channel, "callback" => callback} <- conn.body_params,
         {:ok, _} <- Hub.subscribe(channel, callback) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  post "/unsubscribe" do
    with %{"channel" => channel} <- conn.body_params,
         {:ok, _} <- Hub.unsubscribe(channel) do
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
