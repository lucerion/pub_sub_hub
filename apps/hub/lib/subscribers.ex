defmodule PubSubHub.Subscribers do
  @moduledoc "Subscribers related business logic"

  alias PubSubHub.Hub.Subscriber

  @doc "Fetches subscriber by token"
  @spec find_by_token(String.t()) :: Subscriber.t() | nil
  def find_by_token(_token), do: %Subscriber{}
end
