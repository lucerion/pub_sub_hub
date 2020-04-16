defmodule PubSubHub.Hub.API.PublisherEndpoint do
  @moduledoc "Publisher endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Publishers, Channels}

  post "/auth" do
    conn
    |> current_resource()
    |> auth(conn)
  end

  post "/", private: %{auth: true} do
    with %{"channel_url" => channel_url, "data" => data} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, publisher_id: publisher.id}),
         {:ok, _} <- Hub.broadcast(channel, data) do
      send_response(conn, :ok)
    end
  end

  post "/channel", private: %{auth: true} do
    with %{"channel_url" => channel_url, "channel_secret" => channel_secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         {:ok, _channel} <- Channels.create(%{url: channel_url, secret: channel_secret, publisher_id: publisher.id}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/channel", private: %{auth: true} do
    with %{"channel_url" => channel_url} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, publisher_id: publisher.id}),
         {:ok, _channel} <- Channels.delete(channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  defp current_resource(%Plug.Conn{body_params: %{"email" => email}}), do: Publishers.find_by(%{email: email})
  defp current_resource(%Plug.Conn{private: %{token: token}}), do: Publishers.find_by(%{token: token})
  defp current_resource(_conn), do: nil
end
