defmodule PubSubHub.Hub.Secret do
  @moduledoc "Secret keys functions"

  @default_secret_key_length 16

  @doc "Generates random secret key"
  @spec generate(integer) :: String.t()
  def generate(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64
    |> binary_part(0, length)
  end

  def generate, do: generate(@default_secret_key_length)
end
