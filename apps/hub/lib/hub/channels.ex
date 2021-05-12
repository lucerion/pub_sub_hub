defmodule PubSubHub.Hub.Channels do
  @moduledoc "Channels manipulation functions"

  import Ecto.Query

  alias PubSubHub.Hub.{Channels.Channel, Repo}

  @doc "Fetches a channel by criteria"
  @spec find_by(map) :: Channel.t() | nil
  def find_by(%{url: url}) do
    Channel
    |> by_url_query(url)
    |> Repo.one()
  end

  def find_by(%{url: url, user_id: user_id}) do
    Channel
    |> by_url_query(url)
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

  defp by_url_query(query, url), do: where(query, url: ^url)
end
