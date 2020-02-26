defmodule PubSubHub.Hub.Subscriptions.Subscription do
  @moduledoc "Subscription model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Subscribers.Subscriber, Channels.Channel}

  @type t :: %__MODULE__{
          callback_url: String.t(),
          subscriber_id: integer,
          channel_id: integer
        }

  @type create_attributes :: %{
          callback_url: String.t(),
          subscriber_id: Subscriber.id() | nil,
          channel_id: Channel.id() | nil
        }

  @create_allowed_attributes ~w[callback_url subscriber_id channel_id]a
  @create_required_attributes ~w[callback_url subscriber_id channel_id]a

  schema "subscriptions" do
    field(:callback_url, :string)

    belongs_to(:subscriber, Subscriber)
    belongs_to(:channel, Channel)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = subscription, attributes \\ %{}) do
    subscription
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
    |> unique_constraint(:subscriber_id, name: :subscriptions_subscriber_id_channel_id)
  end
end
