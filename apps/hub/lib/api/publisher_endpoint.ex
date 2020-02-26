defmodule PubSubHub.Hub.API.PublisherEndpoint do
  @moduledoc "Publisher endpoint"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.{Publishers, Secret, Token}

  post "/verify" do
    with %{"email" => email, "secret" => secret} <- conn.body_params,
         publisher when not is_nil(publisher) <- Publishers.find_by(%{email: email}),
         true <- Secret.verify(publisher, secret),
         {:ok, token} <- Token.refresh(publisher) do
      send_resp(conn, 200, token)
    else
      _ -> send_response(conn, :unprocessable_entity)
    end
  end
end
