defmodule PubSubHub.Publisher do
  @moduledoc "Service that sends channels data to the Hub"

  @type response :: {:ok, String.t()} | {:error, String.t()} | {:error, any}

  @hub_url Application.get_env(:hub, :url)
  @publisher_url "#{@hub_url}/publisher"
  @channel_url "#{@hub_url}/channel"

  @headers ["Content-Type": "multipart/mixed"]

  @doc "Authenticate publisher"
  @spec auth(%{email: String.t(), secret: String.t()}) :: response
  def auth(params), do: post("#{@publisher_url}/auth", params)

  @doc "Creates a channel"
  @spec create_channel(%{token: String.t(), url: String.t(), channel_secret: String.t()}) :: response
  def create_channel(params), do: post(@channel_url, params)

  @doc "Deletes a channel"
  @spec delete_channel(%{token: String.t(), url: String.t()}) :: response
  def delete_channel(params) do
    case HTTPoison.request(:delete, @channel_url, {:multipart, request_params(params)}, request_headers(params)) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, nil}
      {:ok, %HTTPoison.Response{status_code: 422, body: error_message}} -> {:error, error_message}
      error -> error
    end
  end

  @doc "Publishes data to Subscribers"
  @spec publish(%{token: String.t(), channel_url: String.t(), data: String.t()}) :: response
  def publish(params), do: post("#{@publisher_url}/publish", params)

  defp post(url, params) do
    case HTTPoison.post(url, {:multipart, request_params(params)}, request_headers(params)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 422, body: error_message}} -> {:error, error_message}
      error -> error
    end
  end

  defp request_params(params) do
    params
    |> Map.delete(:token)
    |> Enum.map(fn {key, value} -> {to_string(key), value} end)
  end

  defp request_headers(%{token: token}), do: @headers ++ ["Authorization": "Bearer #{token}"]
  defp request_headers(_), do: @headers
end
