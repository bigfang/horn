defmodule Horn.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :horn,
      version: @version,
      elixir: "~> 1.7",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A weird Flask scaffolding tool"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Horn]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/bigfang/horn"},
      files: ~w(lib .formatter.exs mix.exs README* templates)
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
