defmodule Mix.Tasks.Horn.New do
  use Mix.Task

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Horn v#{@version} application"

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Horn v#{@version}")
  end
end
