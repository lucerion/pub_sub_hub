defmodule PubSubHub.Hub.RPC.Publisher do
  @moduledoc "Publisher RPC functions"

  use PubSubHub.Hub.RPC

  alias PubSubHub.Hub.{Users, Channels, Subscriptions, Subscriptions.Subscription, Secret, Token}
  alias PubSubHub.Hub.RPC.Hub

  @doc "Creates a Publisher channel"
  @spec create_channel(%{token: Token.t(), url: String.t(), channel_secret: Secret.t()}) :: term
  def create_channel(%{token: token, url: url, channel_secret: channel_secret}) do
    case Users.find_by(%{token: token}) do
      nil ->
        send_response({:error, nil})

      publisher ->
        %{url: url, secret: channel_secret, user_id: publisher.id}
        |> Channels.create()
        |> send_response()
    end
  end

  @doc "Deletes a Publisher channel"
  @spec delete_channel(%{token: Token.t(), url: String.t()}) :: term
  def delete_channel(%{token: token, url: url}) do
    with publisher when not is_nil(publisher) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: url, user_id: publisher.id}) do
      channel
      |> Channels.delete()
      |> send_response()
    end
  end

  @doc "Sends data to Hub"
  @spec publish(%{token: Token.t(), channel_url: String.t(), data: any}) :: term
  def publish(%{token: token, channel_url: channel_url, data: data}) do
    with publisher when not is_nil(publisher) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, user_id: publisher.id}) do
      %{channel_id: channel.id}
      |> Subscriptions.filter()
      |> Hub.broadcast(data)

      send_response({:ok, nil})
    end
  end

  defp send_response(response), do: send_response(response, @publisher)
end
