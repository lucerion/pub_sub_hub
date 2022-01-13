defmodule PubSubHub.Hub.Channels.Channel do
  @moduledoc "Channel model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Users.User, Subscriptions.Subscription, Secret}

  @type t :: %__MODULE__{
          name: String.t(),
          secret_hash: String.t(),
          user_id: User.id()
        }

  @type id :: String.t() | integer

  @type attributes :: %{
          name: String.t(),
          secret: Secret.t(),
          user_id: User.id() | nil
        }

  @allowed_attributes ~w[secret name user_id]a
  @required_attributes ~w[secret name user_id]a

  schema "channels" do
    field(:name, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)

    belongs_to(:user, User)
    has_many(:subscriptions, Subscription, on_delete: :delete_all)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, attributes) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = channel, attributes) do
    channel
    |> cast(attributes, @allowed_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:name, name: :channels_name_user_id_index)
    |> Secret.hash_secret()
  end
end
