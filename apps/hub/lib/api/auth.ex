defmodule PubSubHub.Hub.API.Auth do
  @moduledoc "Auth plug"

  import Plug.Conn

  def init(options), do: options

  def call(%Plug.Conn{private: %{auth: true}} = conn, _options), do: auth(conn)
  def call(%Plug.Conn{} = conn, _options), do: conn

  defp auth(%Plug.Conn{} = conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> put_private(conn, :token, token)
      _ -> send_unauthorized_reponse(conn)
    end
  end

  defp send_unauthorized_reponse(%Plug.Conn{} = conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
