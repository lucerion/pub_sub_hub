defmodule PubSubHub.Hub.Users.User do
  @moduledoc "User model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Channels.Channel, Subscriptions.Subscription, Secret, Token}

  @type t :: %__MODULE__{
          email: String.t(),
          secret_hash: String.t(),
          token: Token.t(),
          rpc_url: String.t(),
          rpc_supervisor: String.t(),
          rpc_module: String.t()
        }

  @type id :: String.t() | integer

  @type create_attributes :: %{
          email: String.t(),
          secret: Secret.t(),
          rpc_url: String.t(),
          rpc_supervisor: String.t(),
          rpc_module: String.t()
        }

  @type update_attributes :: %{
          token: Token.t()
        }

  @create_allowed_attributes ~w[email secret rpc_url rpc_supervisor rpc_module]a
  @create_required_attributes ~w[email secret rpc_url rpc_supervisor rpc_module]a

  @update_allowed_attributes ~w[token]a

  schema "users" do
    field(:email, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:token, :string)
    field(:rpc_url, :string)
    field(:rpc_supervisor, :string)
    field(:rpc_module, :string)

    has_many(:subscriptions, Subscription, on_delete: :delete_all)
    has_many(:channels, Channel, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, create_attributes) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = user, attributes) do
    user
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
    |> unique_constraint(:email)
  end

  @spec update_changeset(%__MODULE__{}, update_attributes) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = user, attributes),
    do: cast(user, attributes, @update_allowed_attributes)
end
