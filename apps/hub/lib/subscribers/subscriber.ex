defmodule PubSubHub.Hub.Subscribers.Subscriber do
  @moduledoc "Subscriber model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.Subscriptions.Subscription

  @type t :: %__MODULE__{
          email: String.t(),
          secret_hash: String.t(),
          token: String.t()
        }

  @create_allowed_attributes ~w[email secret]a
  @create_required_attributes ~w[email secret]a

  @update_allowed_attributes ~w[email token]a
  @update_required_attributes ~w[email token]a

  schema "subscribers" do
    field(:email, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:token, :string)

    has_many(:subscriptions, Subscription, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = subscriber, attributes \\ %{}) do
    subscriber
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
    |> unique_constraint(:email)
    |> hash_secret()
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = subscriber, attributes \\ %{}) do
    subscriber
    |> cast(attributes, @update_allowed_attributes)
    |> validate_required(@update_required_attributes)
    |> unique_constraint(:email)
  end

  defp hash_secret(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp hash_secret(%Ecto.Changeset{changes: %{secret: secret}} = changeset) do
    changeset
    |> put_change(:secret_hash, Bcrypt.hash_pwd_salt(secret))
    |> put_change(:secret, nil)
  end
end
