defmodule Mix.Horn.Model do
  @moduledoc false

  alias Mix.Horn.Model

  defstruct app_name: nil,
            module: nil,
            table: nil,
            generate?: true,
            opts: [],
            alias: nil,
            file: nil,
            attrs: [],
            string_attr: nil,
            plural: nil,
            singular: nil,
            uniques: [],
            assocs: [],
            types: [],
            indexes: [],
            defaults: [],
            human_singular: nil,
            human_plural: nil

  @type_keysords [
    integer: "Integer",
    float: "Float",
    decimal: "Decimal",
    boolean: "Boolean",
    string: "String",
    text: "Text",
    date: "Date",
    time: "Time",
    datetime: "DateTime",
    uuid: "UUID",
    json: "JSON",
    array: "ARRAY",
    references: "references"
  ]

  @valid_types Keyword.keys(@type_keysords)

  def valid_types, do: @valid_types

  def valid?(model) do
    model =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  def new(model_name, model_plural, cli_attrs, opts) do
    app      = "app"    # FIXME:
    base     = Horn.Naming.camelize(Mix.Horn.otp_app())     # AppName
    basename = Horn.Naming.underscore(model_name)
    module   = Enum.join([app, "models", model_name], ".") # app_name.models.Post
    file     = Mix.Horn.model_path(app, basename <> ".py")
    table    = opts[:table] || model_plural
    uniques  = uniques(cli_attrs)   # TODO:
    {assocs, attrs} = partition_attrs_and_assocs(module, attrs(cli_attrs))
    types           = types(attrs)
    props           = props(attrs)
    generate?       = Keyword.get(opts, :model, true)

    singular = Horn.Naming.underscore(model_name)
    string_attr = string_attr(types)

    %Model{
      app_name: app,
      opts: opts,
      module: module,
      table: table,
      alias: module |> String.split(".") |> List.last(),
      file: file,
      attrs: attrs,
      plural: model_plural,
      singular: singular,
      assocs: assocs,
      types: types,
      defaults: model_defaults(attrs),
      uniques: uniques,
      indexes: indexes(table, assocs, uniques),
      human_singular: Horn.Naming.humanize(singular),
      human_plural: Horn.Naming.humanize(model_plural),
      string_attr: string_attr,
      generate?: generate?}
  end

  defp partition_attrs_and_assocs(schema_module, attrs) do
    {assocs, attrs} =
      Enum.split_with(attrs, fn
        {_, {:references, _}} ->
          true
        {key, :references} ->
          Mix.raise """
          Horn generators expect the table to be given to #{key}:references.
          For example:
              mix horn.gen.schema Comment comments body:text post_id:references:posts
          """
        _ -> false
      end)

    assocs =
      Enum.map(assocs, fn {key_id, {:references, source}} ->
        key = String.replace(Atom.to_string(key_id), "_id", "")
        base = schema_module |> Module.split() |> Enum.drop(-1)
        module = Module.concat(base ++ [Horn.Naming.camelize(key)])
        {String.to_atom(key), key_id, inspect(module), source}
      end)

    {assocs, attrs}
  end

  @doc """
  Fetches the unique attributes from attrs.
  """
  def uniques(attrs) do
    attrs
    |> Enum.filter(&String.ends_with?(&1, ":unique"))
    |> Enum.map(&(&1 |> String.split(":", parts: 2) |> hd |> String.to_atom()))
  end

  @doc """
  Parses the attrs as received by generators.
  """
  def attrs(attrs) do
    Enum.map(attrs, fn attr ->
      attr
      |> drop_unique()
      |> String.split(":", parts: 3)
      |> list_to_attr()
      |> validate_attr!()
    end)
  end

  defp drop_unique(info) do
    prefix = byte_size(info) - 7
    case info do
      <<attr::size(prefix)-binary, ":unique">> -> attr
      _ -> info
    end
  end

  defp list_to_attr([key]), do: {String.to_atom(key), :string}
  defp list_to_attr([key, value]), do: {String.to_atom(key), String.to_atom(value)}
  defp list_to_attr([key, comp, value]) do
    {String.to_atom(key), {String.to_atom(comp), String.to_atom(value)}}
  end

  defp validate_attr!({name, :array}) do
    Mix.raise """
    Hoen generators expect the type of the array to be given to #{name}:array.
    For example:
        mix phx.gen.schema Post posts settings:array:string
    """
  end
  defp validate_attr!({_name, type} = attr) when type in @valid_types, do: attr
  defp validate_attr!({_name, {type, _}} = attr) when type in @valid_types, do: attr
  defp validate_attr!({_, type}) do
    Mix.raise "Unknown type `#{inspect type}` given to generator. " <>
              "The supported types are: #{@valid_types |> Enum.sort() |> Enum.join(", ")}"
  end

  defp props(attrs) do
  end

  defp types(attrs) do
    Enum.into(attrs, %{}, fn
      {key, {root, val}} -> {key, {Keyword.get(@type_keysords, root), Keyword.get(@type_keysords, val)}}
      {key, val} -> {key, Keyword.get(@type_keysords, val)}
    end)
  end

  defp string_attr(types) do
    Enum.find_value(types, fn
      {key, {_col, :string}} -> key
      {key, :string} -> key
      _ -> false
    end)
  end

  defp model_defaults(attrs) do
    Enum.into(attrs, %{}, fn
      {key, :boolean}  -> {key, ", default: false"}
      {key, _}         -> {key, ""}
    end)
  end

  defp indexes(table, assocs, uniques) do
    uniques = Enum.map(uniques, fn key -> {key, true} end)
    assocs = Enum.map(assocs, fn {_, key, _, _} -> {key, false} end)

    (uniques ++ assocs)
    |> Enum.uniq_by(fn {key, _} -> key end)
    |> Enum.map(fn
      {key, false} -> "create index(:#{table}, [:#{key}])"
      {key, true}  -> "create unique_index(:#{table}, [:#{key}])"
    end)
  end
end
