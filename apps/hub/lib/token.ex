defmodule PubSubHub.Hub.Token do
  @moduledoc "Token functions"

  alias PubSubHub.Hub.Repo

  @spec refresh(struct) :: {:ok, String.t()} | {:error, nil}
  def refresh(entity) do
    entity
    |> entity.__struct__.update_changeset(%{token: Bcrypt.gen_salt()})
    |> Repo.update()
    |> extract_token()
  end

  defp extract_token({:error, _}), do: {:error, nil}
  defp extract_token({:ok, %{token: token}}), do: {:ok, token}
end
