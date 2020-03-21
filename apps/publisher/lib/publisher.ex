defmodule PubSubHub.Publisher do
  @moduledoc "Service that sends channels data to the Hub"

  @type response :: {:ok, String.t()} | {:error, String.t()} | {:error, any}

  @publisher_url "#{Application.get_env(:hub, :url)}/publisher"
  @channel_url "#{@publisher_url}/channel"

  @headers ["Content-Type": "multipart/mixed"]

  @doc "Authenticate publisher"
  @spec auth(%{email: String.t(), secret: String.t()}) :: response
  def auth(params), do: request(:post, "#{@publisher_url}/auth", params)

  @doc "Publishes data to Subscribers"
  @spec publish(%{token: String.t(), channel_url: String.t(), data: String.t()}) :: response
  def publish(params), do: request(:post, @publisher_url, params)

  @doc "Creates a channel"
  @spec create_channel(%{token: String.t(), channel_url: String.t(), channel_secret: String.t()}) :: response
  def create_channel(params), do: request(:post, @channel_url, params)

  @doc "Deletes a channel"
  @spec delete_channel(%{token: String.t(), channel_url: String.t()}) :: response
  def delete_channel(params), do: request(:delete, @channel_url, params)

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
  defp headers(_params), do: @headers
end
