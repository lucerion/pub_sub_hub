defmodule PubSubHub.Hub.MixProject do
  use Mix.Project

  def project do
    [
      app: :hub,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PubSubHub.Hub.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.3.2"},
      {:postgrex, "~> 0.15.3"},
      {:plug_cowboy, "~> 2.1"}
    ]
  end
end
