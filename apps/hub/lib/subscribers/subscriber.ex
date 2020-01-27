defmodule PubSubHub.Hub.Subscribers.Subscriber do
  @moduledoc "Subscriber model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.Subscriptions.Subscription

  @type t :: %__MODULE__{
          secret_hash: String.t(),
          secret_salt: String.t(),
          token: String.t()
        }

  @create_allowed_attributes ~w[secret]a
  @create_required_attributes ~w[secret]a

  @update_allowed_attributes ~w[token]a
  @update_required_attributes ~w[token]a

  schema "subscribers" do
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:secret_salt, :string)
    field(:token, :string)

    has_many(:subscriptions, Subscription, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = subscriber, attributes \\ %{}) do
    subscriber
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = subscriber, attributes \\ %{}) do
    subscriber
    |> cast(attributes, @update_allowed_attributes)
    |> validate_required(@update_required_attributes)
  end
end
