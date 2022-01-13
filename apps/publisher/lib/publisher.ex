defmodule PubSubHub.Publisher do
  @moduledoc "A service that sends data via channels to the hub"

  @type response :: {:ok, any} | {:error, any}

  @url Application.get_env(:hub, :rpc_url)
  @supervisor Application.get_env(:hub, :rpc_supervisor)
  @module Application.get_env(:hub, :rpc_publisher_module)

  @doc "Authenticate on Hub"
  @spec auth(%{email: String.t(), secret: String.t()}) :: term
  def auth(params), do: call(:auth, params)

  @doc "Creates a channel"
  @spec create_channel(%{token: String.t(), name: String.t(), secret: String.t()}) :: term
  def create_channel(params), do: call(:create_channel, params)

  @doc "Deletes a channel"
  @spec delete_channel(%{token: String.t(), name: String.t()}) :: term
  def delete_channel(params), do: call(:delete_channel, params)

  @doc "Publish data"
  @spec publish(%{token: String.t(), channel_name: String.t(), data: any}) :: term
  def publish(params), do: call(:publish, params)

  @doc "Gets response from Hub"
  @spec receive(response) :: response
  def receive(response), do: response

  defp call(function, options) do
    {@supervisor, String.to_atom(@url)}
    |> Task.Supervisor.async(@module, function, [options])
    |> Task.await()
  end
end
