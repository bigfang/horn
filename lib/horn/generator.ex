defmodule Horn.New.Generator do
  @moduledoc false
  import Mix.Generator
  alias Horn.New.{Project}

  @callback prepare_project(Project.t()) :: Project.t()
  @callback generate(Project.t()) :: Project.t()

  defmacro __using__(_env) do
    quote do
      @behaviour unquote(__MODULE__)
      import unquote(__MODULE__)
      import Mix.Generator
      Module.register_attribute(__MODULE__, :templates, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    root = Path.expand("../../templates", __DIR__)

    templates_ast =
      for {name, mappings} <- Module.get_attribute(env.module, :templates) do
        for {format, source, _, _} <- mappings, format != :keep do
          path = Path.join(root, source)

          quote do
            @external_resource unquote(path)
            def render(unquote(name), unquote(source)), do: unquote(File.read!(path))
          end
        end
      end

    quote do
      unquote(templates_ast)
      def template_files(name), do: Keyword.fetch!(@templates, name)
    end
  end

  defmacro template(name, mappings) do
    quote do
      @templates {unquote(name), unquote(mappings)}
    end
  end

  def copy_from(%Project{} = project, mod, name) when is_atom(name) do
    mapping = mod.template_files(name)

    for {format, source, project_location, target_path} <- mapping do
      target = Project.join_path(project, project_location, target_path)

      case format do
        :keep ->
          File.mkdir_p!(target)

        :text ->
          create_file(target, mod.render(name, source))

        :append ->
          append_to(Path.dirname(target), Path.basename(target), mod.render(name, source))

        :eex ->
          contents = EEx.eval_string(mod.render(name, source), project.binding, file: source)
          create_file(target, contents)
      end
    end
  end

  def append_to(path, file, contents) do
    file = Path.join(path, file)
    File.write!(file, File.read!(file) <> contents)
  end

  def put_binding(%Project{opts: _opts} = project) do
    binding = [
      app_name: project.app,
      app_module: project.app_mod,
      pypi: project.pypi,
      secret_key_base: random_string(64),
      prod_secret_key_base: random_string(64),
      signing_salt: random_string(8),
      generators: nil_if_empty(project.generators)
    ]

    %Project{project | binding: binding}
  end

  defp nil_if_empty([]), do: nil
  defp nil_if_empty(other), do: other

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end
end
