defmodule PubSubHub.Hub.Token do
  @moduledoc "Token functions"

  alias PubSubHub.Hub.Repo

  @default_secret_key_length 16

  @doc "Generates random secret key"
  @spec generate(integer) :: String.t()
  def generate(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end

  def generate, do: generate(@default_secret_key_length)

  @spec refresh(struct) :: {:ok, String.t()} | {:error, nil}
  def refresh(entity) do
    entity
    |> entity.__struct__.update_changeset(%{token: generate()})
    |> Repo.update()
    |> extract_token()
  end

  defp extract_token({:error, _}), do: {:error, nil}
  defp extract_token({:ok, %{token: token}}), do: {:ok, token}
end
