defmodule PubSubHub.Hub.Router do
  @moduledoc "Hub router"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.API.{ChannelEndpoint, SubscriptionEndpoint, SubscriberEndpoint}

  plug(Plug.Parsers, parsers: [:urlencoded])

  forward("/channel", to: ChannelEndpoint)
  forward("/subscriber", to: SubscriberEndpoint)
  forward("/subscription", to: SubscriptionEndpoint)

  match _ do
    send_response(conn, :not_found)
  end
end
