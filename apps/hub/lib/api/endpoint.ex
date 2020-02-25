defmodule PubSubHub.Hub.API.Endpoint do
  @moduledoc "Endpoint common logic"

  defmacro __using__(_opts) do
    quote do
      use Plug.Router

      alias Plug.Conn.Status

      plug(:match)
      plug(:dispatch)

      defp send_response(conn, reason) do
        status_code = Status.code(reason)
        reason_phrase = Status.reason_phrase(status_code)

        send_resp(conn, status_code, reason_phrase)
      end
    end
  end
end
