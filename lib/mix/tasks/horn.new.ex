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
    # |> prompt_to_install_deps(Single)
  end

  defp parse_opts(argv) do
    case OptionParser.parse(argv, strict: @switches) do
      {opts, argv, []} ->
        {opts, argv}

      {_opts, _argv, [switch | _]} ->
        Mix.raise("Invalid option: " <> switch_to_string(switch))
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
