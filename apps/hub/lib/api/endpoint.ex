defmodule PubSubHub.Hub.API.Endpoint do
  @moduledoc "Endpoint common logic"

  defmacro __using__(_opts) do
    quote do
      use Plug.Router

      require Logger

      alias Plug.Conn.Status
      alias PubSubHub.Hub.{Secret, Token}

      plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

      plug(:match)
      plug(PubSubHub.Hub.API.Auth)
      plug(:dispatch)

      defp send_response(%Plug.Conn{} = conn, reason_atom) do
        status_code = Status.code(reason_atom)
        reason_phrase = Status.reason_phrase(status_code)
        send_response(conn, reason_atom, reason_phrase)
      end

      defp send_response(%Plug.Conn{} = conn, reason_atom, body),
        do: send_resp(conn, Status.code(reason_atom), body)

      defp auth(nil, conn), do: send_response(conn, :unprocessable_entity)

      defp auth(user, %Plug.Conn{body_params: body_params} = conn) do
        with %{"secret" => secret} <- body_params,
             true <- Secret.verify(user, secret),
             {:ok, token} <- Token.refresh(user) do
          send_response(conn, :ok, token)
        else
          _ -> send_response(conn, :unprocessable_entity)
        end
      end

      defp current_resource(%Plug.Conn{body_params: %{"email" => email}}, repo), do: repo.find_by(%{email: email})
      defp current_resource(%Plug.Conn{private: %{token: token}}, repo), do: repo.find_by(%{token: token})
      defp current_resource(_conn, _repo), do: nil

      defp log_error(error) do
        error
        |> inspect()
        |> Logger.error()
      end
    end
  end
end
