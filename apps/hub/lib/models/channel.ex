defmodule PubSubHub.Hub.Channel do
  @moduledoc "Channel model"

  use Ecto.Schema

  import Ecto.Changeset

  alias PubSubHub.Hub.{Publisher, Subscription}

  @type t :: %__MODULE__{
          url: String.t(),
          secret_hash: String.t(),
          secret_salt: String.t(),
          publisher_id: integer
        }

  @allowed_attributes ~w[secret url publisher_id]a
  @required_attributes ~w[secret url publisher_id]a

  schema "channels" do
    field(:url, :string)
    field(:secret, :string, virtual: true)
    field(:secret_hash, :string)
    field(:secret_salt, :string)

    belongs_to(:publisher, Publisher)
    has_many(:subscriptions, Subscription, on_delete: :delete_all)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = channel, attributes \\ %{}) do
    channel
    |> cast(attributes, @allowed_attributes)
    |> validate_required(@required_attributes)
  end
end
