alias PubSubHub.Hub.{Subscribers, Publishers}

{:ok, subscriber } = Subscribers.create(%{email: "subscriber@example.com", secret: "subscriber_secret"})
{:ok, publisher} = Publishers.create(%{email: "publisher@example.com", secret: "publisher_secret"})
