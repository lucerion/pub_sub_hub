defmodule PubSubHub.Hub.API.Auth do
  @moduledoc "Auth plug"

  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    case conn.private do
      %{auth: true} -> auth(conn)
      _ -> conn
    end
  end

  defp auth(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> put_private(conn, :token, token)
      _ -> send_unauthorized_reponse(conn)
    end
  end

  defp send_unauthorized_reponse(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
