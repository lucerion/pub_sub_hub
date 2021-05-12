defmodule PubSubHub.Hub.RPC.Hub do
  @moduledoc "Hub RPC functions"

  use PubSubHub.Hub.RPC

  alias PubSubHub.Hub.Subscriptions.Subscription

  @doc "Sends data to the subscribers"
  def broadcast(%Subscription{callback_url: callback_url}, data),
    do: send_response(data, %{url: callback_url, supervisor: @subscriber.supervisor, module: @subscriber.module})

  def broadcast(subscriptions, data), do: Enum.each(subscriptions, &broadcast(&1, data))
end
