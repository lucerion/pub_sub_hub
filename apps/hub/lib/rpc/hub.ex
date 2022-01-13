defmodule PubSubHub.Hub.RPC.Hub do
  @moduledoc "Hub RPC functions"

  use PubSubHub.Hub.RPC

  alias PubSubHub.Hub.Subscriptions.Subscription

  @doc "Sends data to the subscribers"
  def broadcast(%Subscription{}, data),
    do: send_response(data, @subscriber)

  def broadcast(subscriptions, data), do: Enum.each(subscriptions, &broadcast(&1, data))
end
