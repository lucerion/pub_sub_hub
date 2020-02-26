defmodule PubSubHub.Hub.API.SubscriberEndpoint do
  @moduledoc "Subscriber endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Subscribers, Secret, Token}

  post "/verify" do
    with %{"email" => email, "secret" => secret} <- conn.body_params,
         subscriber when not is_nil(subscriber) <- Subscribers.find_by(%{email: email}),
         true <- Secret.verify(subscriber, secret),
         {:ok, token} <- Token.refresh(subscriber) do
      send_resp(conn, 200, token)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
