defmodule PubSubHub.Hub.Subscriptions.Subscription do
  @moduledoc "Subscription model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Users.User, Channels.Channel}

  @type t :: %__MODULE__{
          callback_url: String.t(),
          user_id: User.id(),
          channel_id: Channel.id()
        }

  @type attributes :: %{
          callback_url: String.t(),
          user_id: User.id() | nil,
          channel_id: Channel.id() | nil
        }

  @allowed_attributes ~w[callback_url user_id channel_id]a
  @required_attributes ~w[callback_url user_id channel_id]a

  schema "subscriptions" do
    field(:callback_url, :string)

    belongs_to(:user, User)
    belongs_to(:channel, Channel)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = subscription, attributes) do
    subscription
    |> cast(attributes, @allowed_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:user_id, name: :subscriptions_user_id_channel_id)
  end
end
