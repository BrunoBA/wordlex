defmodule Wordlex.MixProject do
  use Mix.Project

  def project do
    [
      app: :wordlex,
      version: "0.1.0",
      description: "Core game logic for a Wordle-inspired word guessing game",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "Wordlex",
      source_url: "https://github.com/BrunoBA/wordlex",
      homepage_url: "https://github.com/BrunoBA/wordlex",
      docs: &docs/0
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/you/wordlex"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.40.1"}
    ]
  end
end
