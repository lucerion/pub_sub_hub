defmodule PubSubHub.Hub.API.Endpoint do
  @moduledoc "Endpoint common logic"

  defmacro __using__(_opts) do
    quote do
      use Plug.Router

      alias Plug.Conn.Status

      plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

      plug(:match)
      plug(:dispatch)

      defp send_response(conn, reason_atom) do
        status_code = Status.code(reason_atom)
        reason_phrase = Status.reason_phrase(status_code)

        send_response(conn, reason_atom, reason_phrase)
      end

      defp send_response(conn, reason_atom, body) do
        status_code = Status.code(reason_atom)

        send_resp(conn, status_code, body)
      end
    end
  end
end
