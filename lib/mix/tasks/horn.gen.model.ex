defmodule Mix.Tasks.Horn.Gen.Model do
  @shortdoc "Generates models"

  @moduledoc false

  use Mix.Task

  alias Mix.Horn.Model

  @switches [table: :string]

  @doc false
  def run(args) do
    model = build(args, [])
    paths = Mix.Horn.generator_paths()

    prompt_for_conflicts(model)

    model
    |> copy_new_files(paths, model: model)
    |> print_shell_instructions()
  end

  @doc false
  def build(args, parent_opts, help \\ __MODULE__) do
    {model_opts, parsed, _} = OptionParser.parse(args, switches: @switches)
    [model_name, plural | attrs] = validate_args!(parsed, help)

    opts = Keyword.merge(parent_opts, model_opts)

    model = Model.new(model_name, plural, attrs, opts)
    model
  end

  defp prompt_for_conflicts(model) do
    model
    |> files_to_be_generated()
    |> Mix.Horn.prompt_for_conflicts()
  end

  @doc false
  def files_to_be_generated(%Model{} = model) do
    [{:eex, "model.py", model.file}]
  end

  @doc false
  def copy_new_files(%Model{} = model, paths, binding) do
    files = files_to_be_generated(model)
    Mix.Horn.copy_from(paths, "templates/horn.gen.model", binding, files)

    model
  end

  @doc false
  def validate_args!([model, plural | _] = args, help) do
    cond do
      not Model.valid?(model) ->
        help.raise_with_help("Expected the model argument, #{inspect(model)}, to be a valid module name")

      String.contains?(plural, ":") or plural != Macro.underscore(plural) ->
        help.raise_with_help(
          "Expected the plural argument, #{inspect(plural)}, to be all lowercase using snake_case convention"
        )

      true ->
        args
    end
  end

  def validate_args!(_, help) do
    help.raise_with_help("Invalid arguments")
  end

  @doc false
  def print_shell_instructions(%Model{} = model) do
    Mix.shell.info """
    Remember to update your repository by running migrations:
        $ flask db upgrade
    """
  end
end
