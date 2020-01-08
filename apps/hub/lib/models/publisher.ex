defmodule PubSubHub.Hub.Publisher do
  @moduledoc "Publisher model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.Channel

  @type t :: %__MODULE__{
          secret_hash: String.t(),
          secret_salt: String.t(),
          token: String.t()
        }

  @create_allowed_attributes ~w[secret]a
  @create_required_attributes ~w[secret]a

  @update_allowed_attributes ~w[token]a
  @update_required_attributes ~w[token]a

  schema "publishers" do
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:secret_salt, :string)
    field(:token, :string)

    has_many(:channels, Channel, on_delete: :delete_all)

    timestamps()
  end

  @spec create_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = publisher, attributes \\ %{}) do
    publisher
    |> cast(attributes, @create_allowed_attributes)
    |> validate_required(@create_required_attributes)
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = publisher, attributes \\ %{}) do
    publisher
    |> cast(attributes, @update_allowed_attributes)
    |> validate_required(@update_required_attributes)
  end
end
