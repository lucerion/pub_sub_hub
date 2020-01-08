defmodule PubSubHub.Hub do
  @moduledoc "Push updates to Subscribers"

  @doc "Subscribe to a channel"
  def subscribe(subscriber, channel, callback_url), do: {:ok, nil}

  @doc "Unsubscriber from a channel"
  def unsubscribe(subscriber, channel), do: {:ok, nil}
end
