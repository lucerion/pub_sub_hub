alias PubSubHub.Hub
alias PubSubHub.Hub.{Publishers, Channels, Subscribers}

{:ok, publisher} = Publishers.create(%{email: "publisher@example.com", secret: "publisher_secret"})
{:ok, channel} = Channels.create(%{url: "example.com/channel", publisher_id: publisher.id, secret: "channel_secret"})

{:ok, subscriber} = Subscribers.create(%{email: "subscriber@example.com", secret: "subscriber_secret"})
{:ok, subscription} = Hub.subscribe(subscriber, channel, "example.com/callback")
