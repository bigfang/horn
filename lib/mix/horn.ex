defmodule Mix.Horn do
  @moduledoc false

  def generator_paths do
    [".", :horn]
  end

  @doc """
  Returns the flask app from the current dir
  """
  def otp_app do
    System.cwd()
    |> String.split("/")
    |> Enum.at(-1)
  end

  @doc """
  Returns the model path to be used in generated model files.
  """
  def model_path(app, rel_path) do
    Path.join([System.cwd(), app, 'models', rel_path])
  end

  @doc """
  Copies files from source dir to target dir
  according to the given map.
  Files are evaluated against EEx according to
  the given binding.
  """
  def copy_from(apps, source_dir, binding, mapping) when is_list(mapping) do
    roots = Enum.map(apps, &to_app_source(&1, source_dir))

    for {format, source_file_path, target} <- mapping do
      source =
        Enum.find_value(roots, fn root ->
          source = Path.join(root, source_file_path)
          if File.exists?(source), do: source
        end) || raise "could not find #{source_file_path} in any of the sources"

      case format do
        :text -> Mix.Generator.create_file(target, File.read!(source))
        :eex  -> Mix.Generator.create_file(target, EEx.eval_file(source, binding))
        :new_eex ->
          if File.exists?(target) do
            :ok
          else
            Mix.Generator.create_file(target, EEx.eval_file(source, binding))
          end
      end
    end
  end

  @doc """
  Prompts to continue if any files exist.
  """
  def prompt_for_conflicts(generator_files) do
    file_paths = Enum.map(generator_files, fn {_, _, path} -> path end)

    case Enum.filter(file_paths, &File.exists?(&1)) do
      [] -> :ok
      conflicts ->
        Mix.shell.info"""
        The following files conflict with new files to be generated:
        #{conflicts |> Enum.map(&"  * #{&1}") |> Enum.join("\n")}
        See the --web option to namespace similarly named resources
        """
        unless Mix.shell.yes?("Proceed with interactive overwrite?") do
          System.halt()
        end
    end
  end

  defp to_app_source(path, source_dir) when is_binary(path),
    do: Path.join(path, source_dir)
  defp to_app_source(app, source_dir) when is_atom(app),
    do: Application.app_dir(app, source_dir)
end
