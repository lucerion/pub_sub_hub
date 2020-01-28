defmodule PubSubHub.Hub.Subscriptions.Subscription do
  @moduledoc "Subscription model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Subscribers.Subscriber, Channels.Channel}

  @type t :: %__MODULE__{
          subscriber_id: integer,
          channel_id: integer
        }

  @allowed_attributes ~w[subscriber_id channel_id]a
  @required_attributes ~w[subscriber_id channel_id]a

  schema "subscriptions" do
    belongs_to(:subscriber, Subscriber)
    belongs_to(:channel, Channel)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = subscription, attributes \\ %{}) do
    subscription
    |> cast(attributes, @allowed_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:subscriber_id, name: :subscriptions_subscriber_id_channel_id)
  end
end
