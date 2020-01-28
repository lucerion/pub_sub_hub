defmodule PubSubHub.Hub.Publishers.Publisher do
  @moduledoc "Publisher model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.Channels.Channel

  @type t :: %__MODULE__{
          email: String.t(),
          secret_hash: String.t(),
          token: String.t()
        }

  @create_allowed_attributes ~w[email secret]a
  @create_required_attributes ~w[email secret]a

  @update_allowed_attributes ~w[email token]a
  @update_required_attributes ~w[email token]a

  schema "publishers" do
    field(:email, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:token, :string)

    has_many(:channels, Channel, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = publisher, attributes \\ %{}) do
    publisher
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
    |> unique_constraint(:email)
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = publisher, attributes \\ %{}) do
    publisher
    |> cast(attributes, @update_allowed_attributes)
    |> unique_constraint(:email)
  end
end
