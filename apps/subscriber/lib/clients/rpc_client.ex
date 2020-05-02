defmodule PubSubHub.Subscriber.Clients.RPCClient do
  @moduledoc "Functions for work with Hub RPC"

  @type response :: {:ok, any} | {:error, any}

  @hub_url Application.get_env(:hub, :rpc_url)
  @hub_supervisor PubSubHub.Hub.RPC.Supervisor
  @hub_app PubSubHub.Hub.RPC.SubscriberRPC

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
    {@hub_supervisor, String.to_atom(@hub_url)}
    |> Task.Supervisor.async(@hub_app, function, [options])
    |> Task.await()
  end
end
