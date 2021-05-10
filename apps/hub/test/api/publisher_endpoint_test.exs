defmodule PubSubHub.Hub.Test.API.PublisherEndpoint do
  use PubSubHub.Hub.Test.API.EndpointCase

  @publisher_endpoint_url "#{Application.get_env(:hub, :url)}/publisher"
  @channel_endpoint_url "#{@publisher_endpoint_url}/channel"

  @publisher_secret "publisher_secret"
  @publisher_email "publisher@example.com"

  @channel_url "http://example.com/channel"
  @channel_secret "channel_secret"

  alias PubSubHub.Hub.{
    Users,
    Users.User,
    Channels,
    Channels.Channel,
    Subscriptions,
    Token
  }

  setup do
    {:ok, publisher} = Users.create(%{email: @publisher_email, secret: @publisher_secret})
    {:ok, token} = Token.refresh(publisher)

    {:ok, publisher: publisher, token: token}
  end

  describe "POST /publisher/auth" do
    test "returns token", %{publisher: publisher} do
      {:ok, token} =
        request(:post, "#{@publisher_endpoint_url}/auth", %{email: publisher.email, secret: @publisher_secret})

      updated_publisher = Users.find_by(%{email: publisher.email})

      assert token == updated_publisher.token
    end
  end

  describe "POST /publisher" do
    test "publish data", %{publisher: publisher, token: token} do
      {:ok, channel} = create_channel(publisher)
      create_subscription(channel)

      response =
        request(:post, @publisher_endpoint_url, %{
          token: token,
          channel_url: @channel_url,
          data: "data"
        })

      assert success_response(response)
    end
  end

  describe "POST /publisher/channel" do
    test "creates a channel", %{token: token, publisher: publisher} do
      response =
        request(:post, @channel_endpoint_url, %{
          token: token,
          channel_url: @channel_url,
          channel_secret: @channel_secret
        })

      assert success_response(response)
      assert channel(publisher).url == @channel_url
    end
  end

  describe "DELETE /publisher/channel" do
    test "deletes a channel", %{token: token, publisher: publisher} do
      create_channel(publisher)

      response = request(:delete, @channel_endpoint_url, %{token: token, channel_url: @channel_url})

      assert success_response(response)
      assert publisher |> channel() |> is_nil()
    end
  end

  defp channel(%User{id: user_id}), do: Channels.find_by(%{url: @channel_url, user_id: user_id})

  defp create_channel(%User{id: user_id}),
    do: Channels.create(%{url: @channel_url, secret: @channel_secret, user_id: user_id})

  defp create_subscription(%Channel{id: channel_id}) do
    {:ok, subscriber} = Users.create(%{email: "subscriber@example.com", secret: "subscriber_secret"})

    {:ok, _subscription} =
      Subscriptions.create(%{
        user_id: subscriber.id,
        channel_id: channel_id,
        callback_url: "http://example.com"
      })
  end
end
