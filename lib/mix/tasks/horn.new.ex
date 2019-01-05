defmodule Mix.Tasks.Horn.New do
  use Mix.Task
  alias Horn.New.{Generator, Project, Single}

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Horn v#{@version} application"

  @switches [app: :string, html: :boolean]

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Horn v#{@version}")
  end

  def run(argv) do
    case parse_opts(argv) do
      {_opts, []} ->
        Mix.Tasks.Help.run(["horn.new"])

      {opts, [base_path | _]} ->
        generate(base_path, opts)
    end
  end

  def generate(base_path, opts) do
    base_path
    |> Project.new(opts)
    |> Single.prepare_project()
    |> Generator.put_binding()
    # |> validate_project()
    |> Single.generate()
    |> prompt_to_install_deps()
  end

  defp prompt_to_install_deps(%Project{} = project) do
    install? = Mix.shell.yes?("\nFetch and install dependencies?")

    cd_step = ["$ cd #{relative_app_path(project.project_path)}"]

    maybe_cd(project.project_path, fn ->
      pipenv_step = install_pipenv(install?, project)

      print_missing_steps(cd_step ++ pipenv_step)
      print_flask_steps(project.app)
    end)
  end
  defp maybe_cd(path, func), do: path && File.cd!(path, func)
  defp install_pipenv(install?, project) do
    maybe_cmd "pipenv install --dev",
              File.exists?("Pipfile"), install? && System.find_executable("pipenv")
  end

  defp parse_opts(argv) do
    case OptionParser.parse(argv, strict: @switches) do
      {opts, argv, []} ->
        {opts, argv}

      {_opts, _argv, [switch | _]} ->
        Mix.raise("Invalid option: " <> switch_to_string(switch))
    end
  end

  defp print_missing_steps(steps) do
    Mix.shell.info """
    We are almost there! The following steps are missing:
        #{Enum.join(steps, "\n    ")}
    """
  end

  defp print_flask_steps(app) do
    Mix.shell.info """
    Start your flask app with:
        $ pipenv shell
        $ FLASK_APP=#{app}/run flask run
    """
  end

  defp relative_app_path(path) do
    case Path.relative_to_cwd(path) do
      ^path -> Path.basename(path)
      rel   -> rel
    end
  end

  defp maybe_cmd(cmd, should_run?, can_run?) do
    cond do
      should_run? && can_run? ->
        cmd(cmd)
      should_run? ->
        ["$ #{cmd}"]
      true ->
        []
    end
  end

  defp cmd(cmd) do
    Mix.shell.info [:green, "* running ", :reset, cmd]
    case Mix.shell.cmd(cmd, quiet: true) do
      0 ->
        []
      _ ->
        ["$ #{cmd}"]
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val

  ## helpers

  @doc false
  def recompile(regex) do
    if Code.ensure_loaded?(Regex) and function_exported?(Regex, :recompile!, 1) do
      apply(Regex, :recompile!, [regex])
    else
      regex
    end
  end
end
