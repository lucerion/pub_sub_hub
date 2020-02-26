defmodule PubSubHub.Hub.Subscribers do
  @moduledoc "Subscribers related business logic"

  import Ecto.Query

  alias PubSubHub.Hub.{Subscribers.Subscriber, Repo}

  @doc "Fetches subscriber by criteria"
  @spec find_by(map) :: Subscriber.t() | nil
  def find_by(%{token: token}) do
    Subscriber
    |> where(token: ^token)
    |> Repo.one()
  end

  def find_by(%{email: email}) do
    Subscriber
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc "Creates a subscriber"
  @spec create(Subscriber.create_attributes()) :: {:ok, Subscriber.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Subscriber{}
    |> Subscriber.create_changeset(attributes)
    |> Repo.insert()
  end
end
