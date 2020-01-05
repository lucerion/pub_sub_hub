defmodule PubSubHub.Hub do
  @moduledoc "Push updates to Subscribers"

  @doc "Subscribe to a channel"
  @spec subscribe(String.t(), String.t()) :: {:ok, nil}
  def subscribe(channel, callback), do: {:ok, nil}

  @doc "Unsubscriber from a channel"
  def unsubscribe(channel), do: {:ok, nil}
end
