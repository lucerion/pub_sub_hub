defmodule PubSubHub.Subscriber do
  @moduledoc "Service that consumes channels data"

  @type response :: {:ok, String.t()} | {:error, String.t()} | {:error, any}

  @subscriber_url "#{Application.get_env(:hub, :url)}/subscriber"

  @headers ["Content-Type": "multipart/mixed"]

  @doc "Authenticate subscriber"
  @spec auth(%{email: String.t(), secret: String.t()}) :: response
  def auth(params), do: request(:post, "#{@subscriber_url}/auth", params)

  @doc "Subscribes to a channel"
  @spec subscribe(%{
          token: String.t(),
          callback_url: String.t(),
          channel_url: String.t(),
          channel_secret: String.t()
        }) :: response
  def subscribe(params), do: request(:post, @subscriber_url, params)

  @doc "Unsubscribes from a channel"
  @spec unsubscribe(%{token: String.t(), channel_url: String.t(), channel_secret: String.t()}) :: response
  def unsubscribe(params), do: request(:delete, @subscriber_url, params)

  defp request(method, url, params) do
    case HTTPoison.request(method, url, {:multipart, params(params)}, headers(params)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 422, body: error_message}} -> {:error, error_message}
      error -> error
    end
  end

  defp params(params) do
    params
    |> Map.delete(:token)
    |> Enum.map(fn {key, value} -> {to_string(key), value} end)
  end

  defp headers(%{token: token}), do: @headers ++ [Authorization: "Bearer #{token}"]
  defp headers(_), do: @headers
end
