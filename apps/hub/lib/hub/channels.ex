defmodule PubSubHub.Hub.Channels do
  @moduledoc "Channels manipulation functions"

  import Ecto.Query

  alias PubSubHub.Hub.{Channels.Channel, Repo}

  @doc "Fetches a channel by criteria"
  @spec find_by(map) :: Channel.t() | nil
  def find_by(%{name: name}) do
    Channel
    |> by_name_query(name)
    |> Repo.one()
  end

  def find_by(%{name: name, user_id: user_id}) do
    Channel
    |> by_name_query(name)
    |> where(user_id: ^user_id)
    |> Repo.one()
  end

  @doc "Creates a channel"
  @spec create(Channel.attributes()) :: {:ok, Channel.t()} | {:error, Ecto.Changeset.t()}
  def create(attributes) do
    %Channel{}
    |> Channel.changeset(attributes)
    |> Repo.insert()
  end

  @doc "Deletes a channel"
  @spec delete(Channel.t()) :: {:ok, Channel.t()}
  def delete(%Channel{} = channel), do: Repo.delete(channel)

  defp by_name_query(query, name), do: where(query, name: ^name)
end
