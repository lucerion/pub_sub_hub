defmodule PubSubHub.Hub.Users.User do
  @moduledoc "User model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Channels.Channel, Subscriptions.Subscription, Secret, Token}

  @type t :: %__MODULE__{
          email: String.t(),
          secret_hash: String.t(),
          token: Token.t()
        }

  @type id :: String.t() | integer

  @type create_attributes :: %{
          email: String.t(),
          secret: Secret.t()
        }

  @type update_attributes :: %{
          email: String.t(),
          token: Token.t()
        }

  @create_allowed_attributes ~w[email secret]a
  @create_required_attributes ~w[email secret]a

  @update_allowed_attributes ~w[token]a

  schema "users" do
    field(:email, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:token, :string)

    has_many(:subscriptions, Subscription, on_delete: :delete_all)
    has_many(:channels, Channel, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, create_attributes) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = subscriber, attributes) do
    subscriber
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
    |> unique_constraint(:email)
    |> Secret.hash_secret()
  end

  @spec update_changeset(%__MODULE__{}, update_attributes) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = subscriber, attributes),
    do: cast(subscriber, attributes, @update_allowed_attributes)
end