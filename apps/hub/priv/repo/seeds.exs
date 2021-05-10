alias PubSubHub.Hub.Users

{:ok, _publisher} = Users.create(%{email: "publisher@example.com", secret: "publisher_secret"})
{:ok, _subscriber} = Users.create(%{email: "subscriber@example.com", secret: "subscriber_secret"})
