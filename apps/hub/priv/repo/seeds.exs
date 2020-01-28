{:ok, subscriber } = PubSubHub.Hub.Subscribers.create(%{secret: "subscriber_secret", email: "subscriber@example.com"})
