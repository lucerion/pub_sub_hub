alias PubSubHub.Hub.{Publishers, Subscribers}

{:ok, _publisher} = Publishers.create(%{email: "publisher@example.com", secret: "publisher_secret"})
{:ok, _subscriber} = Subscribers.create(%{email: "subscriber@example.com", secret: "subscriber_secret"})
