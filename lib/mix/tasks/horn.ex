defmodule Mix.Tasks.Horn do
  use Mix.Task

  @shortdoc "Prints Horn help information"

  @moduledoc """
  Prints Horn tasks and their information.
      mix horn

  Prints Horn version.
      mix horn -v
  """

  @version Mix.Project.config()[:version]

  @doc false
  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Horn v#{@version}")
  end

  @doc false
  def run(args) do
    case args do
      ["-v"] -> Mix.shell().info("Horn v#{@version}")
      ["--version"] -> Mix.shell().info("Horn v#{@version}")
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix horn")
    end
  end

  defp general() do
    Application.ensure_all_started(:horn)
    Mix.shell().info("Horn v#{Application.spec(:horn, :vsn)}")
    Mix.shell().info("\nA Wired Flask Scaffold Tool")
    Mix.shell().info("\nAvailable tasks:\n")
    Mix.Tasks.Help.run(["--search", "horn."])
  end
end
