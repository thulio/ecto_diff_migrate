defmodule EctoDiffMigrate.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_diff_migrate,
      version: "0.1.0",
      elixir: ">= 1.9.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test] do
    ["lib", "test/support", "test"]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto_sql, ">= 3.2.0", optional: true},
      {:postgrex, ">= 0.0.0", optional: true},
      {:temp, "~> 0.4"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
