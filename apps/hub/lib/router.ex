defmodule PubSubHub.Hub.Router do
  @moduledoc "Hub router"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.API.{PublisherEndpoint, ChannelEndpoint, SubscriberEndpoint, SubscriptionEndpoint}

  forward("/publisher", to: PublisherEndpoint)
  forward("/channel", to: ChannelEndpoint)
  forward("/subscriber", to: SubscriberEndpoint)
  forward("/subscription", to: SubscriptionEndpoint)

  match _ do
    send_response(conn, :not_found)
  end
end
