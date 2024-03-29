defmodule PubSubHub.Publisher.MixProject do
  use Mix.Project

  def project do
    [
      app: :publisher,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PubSubHub.Publisher.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
