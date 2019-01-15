defmodule Mix.Tasks.Horn.New do
  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Horn v#{@version} application"

  @moduledoc """
  Creates a new Horn-Flask project.

  It expects the path of the project as an argument.

      mix horn.new PATH [--app APP]

  A project at the given PATH will be created. The
  default app folder name is "app" unless `--app` is given.

  ## Options

  * `--app` - the name of the application folder. default
    value is `app`

  * `--proj` - the name of the project, the default
    value is the capitalized given PATH. for example,
    if the PATH is `foo_bar`, the default project name is
    `FooBar`

  * `--pypi` - the mirror of pypi, eg: `pypi.doubanio.com`

  * `--bare` - if set, horn will create a bare project without
    `user` module

  ## Example

      mix horn.new foo_bar --app foobar --pypi=pypi.doubanio.com --bare

  the project directory structure looks like:

      .
      ├── foobar
      │  ├── configs
      │  │  └── ...
      │  ├── core
      │  │  └── ...
      │  ├── models
      │  │  └── ...
      │  ├── schemas
      │  │  └── ...
      │  ├── views
      │  │  └── ...
      │  └── ....
      ├── instance
      │  └── ...
      ├── log/
      ├── test
      │  └── ...
      ├── Pipfile
      ├── README.md
      └── ...

  you will find:

  * `app` - the `app` folder is renamed to `foobar`.

  * `Pipfile` - in section `[[source]]`, the url become `https://pypi.doubanio.com/simple`

  * `README.md` - the project name is FooBar
  """
  use Mix.Task
  alias Horn.New.{Flask, Generator, Project}

  @switches [app: :string, proj: :string, pypi: :string, bare: :boolean]

  @doc false
  def run(argv) do
    case parse_opts(argv) do
      {_opts, []} ->
        Mix.Tasks.Help.run(["horn.new"])

      {opts, [base_path | _]} ->
        generate(base_path, opts)
    end
  end

  @doc false
  def generate(base_path, opts) do
    base_path
    |> Project.new(opts)
    |> Flask.prepare_project()
    |> Generator.put_binding()
    |> validate_project()
    |> Flask.generate()
    |> prompt_to_install_deps()
  end

  defp validate_project(%Project{opts: opts} = project) do
    check_app_name!(project.app, !!opts[:app])
    check_directory_existence!(project.project_path)
    check_project_name_validity!(project.app_mod)

    project
  end

  defp prompt_to_install_deps(%Project{} = project) do
    install? = Mix.shell().yes?("\nFetch and install dependencies?")

    cd_step = ["$ cd #{relative_app_path(project.project_path)}"]

    maybe_cd(project.project_path, fn ->
      pipenv_step = install_pipenv(install?)

      print_missing_steps(cd_step ++ pipenv_step)
      print_env_steps(project.app)

      unless Keyword.get(project.binding, :bare) do
        print_migrate_steps(project.app)
      end

      print_flask_steps()
    end)
  end

  defp maybe_cd(path, func), do: path && File.cd!(path, func)

  defp install_pipenv(install?) do
    maybe_cmd("pipenv install --dev", File.exists?("Pipfile"), install? && System.find_executable("pipenv"))
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
    Mix.shell().info("""

    The following steps are missing:

        #{Enum.join(steps, "\n    ")}
    """)
  end

  defp print_env_steps(app) do
    Mix.shell().info("""
    Then configure your flask environment variables:

        $ export FLASK_ENV=development
        $ export FLASK_APP=#{app}.run
    """)
  end

  defp print_migrate_steps(app) do
    Mix.shell().info("""
    And configure your database in #{app}/configs/development.py and run

        $ flask db init
        $ flask db migrate -m "init"
        $ flask db upgrade
    """)
  end

  defp print_flask_steps() do
    Mix.shell().info("""
    Start your flask app with:

        $ pipenv shell
        $ flask run
    """)
  end

  defp relative_app_path(path) do
    case Path.relative_to_cwd(path) do
      ^path -> Path.basename(path)
      rel -> rel
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
    Mix.shell().info([:green, "* running ", :reset, cmd])

    case Mix.shell().cmd(cmd, quiet: false) do
      0 ->
        []

      _ ->
        Mix.shell().info([:red_background, :bright, "* Error:", :reset, :red, " " <> cmd])
        ["$ #{cmd}"]
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val

  defp check_app_name!(name, from_app_flag) do
    unless name =~ recompile(~r/^[a-z][\w_]*$/) do
      extra =
        if from_app_flag do
          ""
        else
          ". The application name is inferred from the path, if you'd like to " <>
            "explicitly name the application then use the `--app APP` option."
        end

      Mix.raise(
        "Application name must start with a letter and have only lowercase " <>
          "letters, numbers and underscore, got: #{inspect(name)}" <> extra
      )
    end
  end

  defp check_directory_existence!(path) do
    if File.dir?(path) and
         not Mix.shell().yes?("The directory #{path} already exists. Are you sure you want to continue?") do
      Mix.raise("Please select another directory for installation.")
    end
  end

  defp check_project_name_validity!(name) do
    unless name =~ recompile(~r/^[A-Z]\w*([A-Z]\w*)*$/) do
      Mix.raise("Project name must start with an uppercase letter (for example: FooBar), got: #{inspect(name)}")
    end
  end

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
