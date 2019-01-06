defmodule Horn.New.Project do
  @moduledoc false
  alias Horn.New.Project

  defstruct base_path: nil,
            app: nil,
            app_mod: nil,
            app_path: nil,
            pypi: nil,
            project_path: nil,
            opts: :unset,
            binding: [],
            generators: []

  def new(project_path, opts) do
    project_path = Path.expand(project_path)
    app = opts[:app] || "app"
    app_mod = opts[:module] || Macro.camelize(Path.basename(project_path))
    pypi = opts[:pypi] || "pypi.org"

    %Project{
      base_path: project_path,
      app: app,
      app_mod: app_mod,
      pypi: pypi,
      opts: opts
    }
  end

  def join_path(%Project{} = project, location, path)
      when location in [:project, :app] do
    project
    |> Map.fetch!(:"#{location}_path")
    |> Path.join(path)
    |> expand_path_with_bindings(project)
  end

  defp expand_path_with_bindings(path, %Project{} = project) do
    Regex.replace(Mix.Tasks.Horn.New.recompile(~r/:[a-zA-Z0-9_]+/), path, fn ":" <> key, _ ->
      project |> Map.fetch!(:"#{key}") |> to_string()
    end)
  end
end
