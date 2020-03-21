defmodule PubSubHub.Hub.Test.API.EndpointCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      use PubSubHub.Hub.Test.API.RepoCase

      import PubSubHub.Hub.Test.API.EndpointCase

      @headers ["Content-Type": "multipart/mixed"]

      defp request(method, url, params) do
        case HTTPoison.request(method, url, {:multipart, params(params)}, headers(params)) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
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

      defp success_response({:ok, "OK"}), do: assert(true)
      defp success_response(_), do: assert(false)
    end
  end
end
