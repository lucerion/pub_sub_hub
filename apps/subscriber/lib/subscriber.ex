defmodule PubSubHub.Subscriber do
  @moduledoc "A service that consumes publishers data"

  @type response :: {:ok, any} | {:error, any}

  @url Application.get_env(:hub, :rpc_url)
  @supervisor PubSubHub.Hub.RPC.Supervisor
  @module PubSubHub.Hub.RPC.Subscriber

  @doc "Authenticate on Hub"
  @spec auth(%{email: String.t(), secret: String.t()}) :: term
  def auth(params), do: call(:auth, params)

  @doc "Subscribes to a channel"
  @spec subscribe(%{
          token: String.t(),
          channel_url: String.t(),
          channel_secret: String.t(),
          callback_url: String.t()
        }) :: term
  def subscribe(params), do: call(:subscribe, params)

  @doc "Unsubscribes from a channel"
  @spec unsubscribe(%{token: String.t(), channel_url: String.t()}) :: term
  def unsubscribe(params), do: call(:unsubscribe, params)

  @doc "Gets response from Hub"
  @spec receive(response) :: response
  def receive(response), do: response

  defp call(function, options) do
    {@supervisor, String.to_atom(@url)}
    |> Task.Supervisor.async(@module, function, [options])
    |> Task.await()
  end
end
