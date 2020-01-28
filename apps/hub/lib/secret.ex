defmodule PubSubHub.Hub.Secret do
  @moduledoc "Secret keys functions"

  @doc "Hashes a secret key"
  @spec hash_secret(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def hash_secret(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  def hash_secret(%Ecto.Changeset{changes: %{secret: secret}} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(:secret_hash, Bcrypt.hash_pwd_salt(secret))
    |> Ecto.Changeset.put_change(:secret, nil)
  end
end
