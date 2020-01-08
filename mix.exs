defmodule PubSubHub.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.0.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 0.5.1"},
      {:credo, "~> 1.1"}
    ]
  end
end
