defmodule PubSubHub.Hub do
  @moduledoc """
  Service that subscribes/unsubscribes Subscribers to Publisher channels and sends Publishers data to the Subscribers
  """

  @doc "Subscribe to a channel"
  def subscribe(subscriber, channel, callback_url), do: {:ok, nil}

  @doc "Unsubscriber from a channel"
  def unsubscribe(subscriber, channel), do: {:ok, nil}
end
