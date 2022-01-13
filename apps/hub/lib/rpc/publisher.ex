defmodule PubSubHub.Hub.RPC.Publisher do
  @moduledoc "Publisher RPC functions"

  use PubSubHub.Hub.RPC

  alias PubSubHub.Hub.{Repo, Users, Channels, Subscriptions, Secret, Token}
  alias PubSubHub.Hub.RPC.Hub

  @doc "Creates a Publisher channel"
  @spec create_channel(%{token: Token.t(), name: String.t(), secret: Secret.t()}) :: term
  def create_channel(%{token: token, name: name, secret: secret}) do
    with publisher when not is_nil(publisher) <- Users.find_by(%{token: token}) do
      %{name: name, secret: secret, user_id: publisher.id}
      |> Channels.create()
      |> send_response(publisher)
    end
  end

  @doc "Deletes a Publisher channel"
  @spec delete_channel(%{token: Token.t(), name: String.t()}) :: term
  def delete_channel(%{token: token, name: name}) do
    with publisher when not is_nil(publisher) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{name: name, user_id: publisher.id}) do
      channel
      |> Channels.delete()
      |> send_response(publisher)
    end
  end

  @doc "Sends data to Hub"
  @spec publish(%{token: Token.t(), channel_name: String.t(), data: any}) :: term
  def publish(%{token: token, channel_name: channel_name, data: data}) do
    with publisher when not is_nil(publisher) <- Users.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{name: channel_name, user_id: publisher.id}) do
      %{channel_id: channel.id}
      |> Subscriptions.filter()
      |> Repo.preload(:user)
      |> Hub.broadcast(data)

      send_response({:ok, nil}, publisher)
    end
  end
end
