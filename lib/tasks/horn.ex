defmodule Mix.Tasks.Horn do
  use Mix.Task

  @shortdoc "Prints Horn help information"

  @moduledoc """
  Prints Horn tasks and their information.
      mix horn
  """

  @doc false
  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix horn")
    end
  end

  defp general() do
    Application.ensure_all_started(:horn)
    Mix.shell().info("Horn v#{Application.spec(:horn, :vsn)}")
    Mix.shell().info("A Wired Flask Scaffold Tool")
    Mix.shell().info("\nAvailable tasks:\n")
    Mix.Tasks.Help.run(["--search", "horn."])
  end
end
