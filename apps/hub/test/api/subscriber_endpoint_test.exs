defmodule PubSubHub.Hub.Test.API.SubscriberEndpoint do
  use PubSubHub.Hub.Test.API.EndpointCase

  @subscriber_endpoint_url "#{Application.get_env(:hub, :url)}/subscriber"

  @subscriber_secret "subscriber_secret"
  @subscriber_email "subscriber@example.com"
  @callback_url "http://example.com/callback"

  @channel_url "http://example.com/channel"
  @channel_secret "channel_secret"

  alias PubSubHub.Hub
  alias PubSubHub.Hub.{Subscribers, Publishers, Channels, Token}

  setup do
    {:ok, subscriber} = Subscribers.create(%{email: @subscriber_email, secret: @subscriber_secret})
    {:ok, token} = Token.refresh(subscriber)

    {:ok, subscriber: subscriber, token: token}
  end

  describe "POST /subscriber/auth" do
    test "returns token", %{subscriber: subscriber} do
      {:ok, token} =
        request(:post, "#{@subscriber_endpoint_url}/auth", %{email: subscriber.email, secret: @subscriber_secret})

      updated_subscriber = Subscribers.find_by(%{email: subscriber.email})

      assert token == updated_subscriber.token
    end
  end

  describe "POST /subscriber" do
    test "subscribes to a channel", %{token: token} do
      create_channel()

      response = request(:post, @subscriber_endpoint_url, %{
        token: token,
        callback_url: "http://example.com/callback",
        channel_url: @channel_url,
        channel_secret: @channel_secret
      })

      assert success_response(response)
    end
  end

  describe "DELETE /subscriber" do
    test "unsubscribes from a channel", %{token: token, subscriber: subscriber} do
      {:ok, channel} = create_channel()
      Hub.subscribe(subscriber, channel, @callback_url)

      response = request(:delete, @subscriber_endpoint_url, %{token: token, channel_url: @channel_url})

      assert success_response(response)
    end
  end

  def create_channel do
    {:ok, publisher} = Publishers.create(%{email: "publisher@example.com", secret: "publisher_secret"})
    Channels.create(%{url: @channel_url, secret: @channel_secret, publisher_id: publisher.id})
  end
end