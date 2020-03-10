defmodule PubSubHub.Hub.API.Router do
  @moduledoc "Hub router"

  use PubSubHub.Hub.API.Endpoint

  alias PubSubHub.Hub.API.{PublisherEndpoint, SubscriberEndpoint}

  forward("/publisher", to: PublisherEndpoint)
  forward("/subscriber", to: SubscriberEndpoint)

  match _ do
    send_response(conn, :not_found)
  end
end
