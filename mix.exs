defmodule Horn.MixProject do
  use Mix.Project

  @version "0.1.2"
  @github "https://github.com/bigfang/horn"

  def project do
    [
      app: :horn,
      version: @version,
      elixir: "~> 1.7",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A weird Flask scaffolding tool",
      source_url: @github,
      homepage_url: @github,
      docs: [
        extras: [
          "README.md"
        ],
        main: "readme"
      ]
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
      links: %{GitHub: @github},
      files: ~w(lib .formatter.exs mix.exs README.md templates)
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
