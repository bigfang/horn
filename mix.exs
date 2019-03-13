defmodule Horn.MixProject do
  use Mix.Project

  @version "0.1.6"
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
      docs: [
        extras: [
          "README.md",
          "guides/quickstart.md",
          "guides/structure.md"
        ],
        main: "readme",
        source_ref: "#{@version}",
        source_url: @github
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
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
