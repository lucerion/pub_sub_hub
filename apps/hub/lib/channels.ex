defmodule PubSubHub.Channels do
  @moduledoc "Channels related business logic"

  alias PubSubHub.Hub.Channel

  @doc "Fetches channel by url"
  @spec find_by_url(String.t()) :: Channel.t() | nil
  def find_by_url(url), do: %Channel{}
end
