defmodule PubSubHub.Hub.API.PublisherEndpoint do
  @moduledoc "Publisher endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Channels, Subscriptions, Subscriptions.Subscription}

  post "/auth" do
    conn
    |> current_resource()
    |> auth(conn)
  end

  post "/", private: %{auth: true} do
    with %{"channel_url" => channel_url, "data" => data} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, user_id: publisher.id}) do
      channel
      |> Subscriptions.filter()
      |> Enum.each(&publish_data(&1, data))

      send_response(conn, :ok)
    end
  end

  post "/channel", private: %{auth: true} do
    with %{"channel_url" => channel_url, "channel_secret" => channel_secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         {:ok, _channel} <- Channels.create(%{url: channel_url, secret: channel_secret, user_id: publisher.id}) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  delete "/channel", private: %{auth: true} do
    with %{"channel_url" => channel_url} <- conn.body_params,
         publisher when not is_nil(publisher) <- current_resource(conn),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, user_id: publisher.id}),
         {:ok, _channel} <- Channels.delete(channel) do
      send_response(conn, :ok)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end

  defp publish_data(%Subscription{callback_url: url}, data) do
    case HTTPoison.request(:post, url, data) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, nil}
      error -> log_error(error)
    end
  end
end
