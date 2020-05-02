defmodule PubSubHub.Hub.RPC.PublisherRPC do
  @moduledoc "Publisher RPC functions"

  use PubSubHub.Hub.RPC

  @repo PubSubHub.Hub.Publishers

  alias PubSubHub.Hub.{Publishers, Channels, Subscriptions, Subscriptions.Subscription, Secret, Token}

  @doc "Authenticate Publisher"
  @spec auth(%{email: String.t(), secret: Secret.t()}) :: term
  def auth(params), do: auth(@publisher, @repo, params)

  @doc "Creates a Publisher channel"
  @spec create_channel(%{token: Token.t(), url: String.t(), channel_secret: Secret.t()}) :: term
  def create_channel(%{token: token, url: url, channel_secret: channel_secret}) do
    case Publishers.find_by(%{token: token}) do
      nil ->
        send_response({:error, nil}, @publisher)

      publisher ->
        %{url: url, secret: channel_secret, publisher_id: publisher.id}
        |> Channels.create()
        |> send_response(@publisher)
    end
  end

  @doc "Deletes a Publisher channel"
  @spec delete_channel(%{token: Token.t(), url: String.t()}) :: term
  def delete_channel(%{token: token, url: url}) do
    with publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: url, publisher_id: publisher.id}) do
      channel
      |> Channels.delete()
      |> send_response(@publisher)
    end
  end

  @doc "Sends data to Hub"
  @spec publish(%{token: Token.t(), channel_url: String.t(), data: any}) :: term
  def publish(%{token: token, channel_url: channel_url, data: data}) do
    with publisher when not is_nil(publisher) <- Publishers.find_by(%{token: token}),
         channel when not is_nil(channel) <- Channels.find_by(%{url: channel_url, publisher_id: publisher.id}) do
      %{channel_id: channel.id}
      |> Subscriptions.filter()
      |> Enum.each(&send_data(&1, data))

      send_response({:ok, nil}, @publisher)
    end
  end

  defp send_response(response), do: send_response(response, @publisher)

  defp send_data(%Subscription{callback_url: callback_url}, data) do
    send_response(data, %{supervisor: @subscriber.supervisor, url: callback_url, app: @subscriber.app})
  end
end
