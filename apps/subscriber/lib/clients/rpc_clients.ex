defmodule PubSubHub.Publisher.Clients.RPCClient do
  @moduledoc "Functions for work with Hub RPC"

  @type response :: {:ok, any} | {:error, any}

  @hub_url Application.get_env(:hub, :rpc_url)
  @hub_supervisor PubSubHub.Hub.RPC.Supervisor
  @hub_app PubSubHub.Hub.RPC.PublisherRPC

  @doc "Authenticate on Hub"
  @spec auth(%{email: String.t(), secret: String.t()}) :: term
  def auth(params), do: call(:auth, params)

  @doc "Creates a channel"
  @spec create_channel(%{token: String.t(), url: String.t(), channel_secret: String.t()}) :: term
  def create_channel(params), do: call(:create_channel, params)

  @doc "Deletes a channel"
  @spec delete_channel(%{token: String.t(), url: String.t()}) :: term
  def delete_channel(params), do: call(:delete_channel, params)

  @doc "Gets response from Hub"
  @spec receive(response) :: response
  def receive(response), do: response

  defp call(function, options) do
    {@hub_supervisor, @hub_url}
    |> Task.Supervisor.async(@hub_app, function, [options])
    |> Task.await()
  end
end
