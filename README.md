# PubSubHub

Proof of concept. Deliver content with pub/sub mechanism via Elixir RPC. Inspired by WebSub.

## Setup

* install dependencies

        mix deps.get

* create `.env` and provide required env variables (see [.env.example](.env.example))

* export env variables

        source .env

* create a database

        mix ecto.create

* run migrations

        mix ecto.migrate

## Usage

* open Hub terminal

        cd ./apps/hub
        iex --sname hub@localhost -S mix

* create Publisher

```elixir
{:ok, _publisher} = PubSubHub.Hub.Users.create(%{
  email: "publisher@example.com",
  secret: "publisher_secret",
  rpc_url: "publisher@localhost",
  rpc_supervisor: "PubSubHub.Publisher.RPC.Supervisor",
  rpc_module: "PubSubHub.Publisher"
})
```

* create Subscriber

```elixir
{:ok, _subscriber} = PubSubHub.Hub.Users.create(%{
  email: "subscriber@example.com",
  secret: "subscriber_secret",
  rpc_url: "subscriber@localhost",
  rpc_supervisor: "PubSubHub.Subscriber.RPC.Supervisor",
  rpc_module: "PubSubHub.Subscriber"
})
```

* open Publisher terminal

        cd ./apps/publisher
        iex --sname publisher@localhost -S mix

* authenticate on Hub

```elixir
{:ok, token} = PubSubHub.Publisher.auth(%{
  email: "publisher@example.com",
  secret: "publisher_secret"
})
```

* create a channel

```elixir
{:ok, _channel} = PubSubHub.Publisher.create_channel(%{
  token: token,
  name: "channel_name",
  secret: "channel_secret"
})
```

* open Subscriber terminal

        cd ./apps/subscriber
        iex --sname publisher@localhost -S mix

* authenticate on Hub

```elixir
{:ok, token} = PubSubHub.Subscriber.auth(%{
  email: "subscriber@example.com",
  secret: "subscriber_secret"
})
```

* subscribe to a channel

```elixir
{:ok, _subscription} = PubSubHub.Subscriber.subscribe(%{
  token: token,
  channel_name: "channel_name",
  channel_secret: "channel_secret",
  callback_url: "subscriber@localhost"
})
```

* as Publisher publish data

```elixir
{:ok, nil} = PubSubHub.Publisher.publish(%{
  token: token,
  channel_name: "channel_name",
  data: "data"
})
```

* as Subscriber unsubscribe from a channel

```elixir
{:ok, _subscription} = PubSubHub.Subscriber.unsubscribe(%{
  token: token,
  channel_name: "channel_name"
})
```

* as Publisher delete a channel

```elixir
{:ok, _channel} = PubSubHub.Publisher.delete_channel(%{
  token: token,
  name: "channel_name"
})
```
