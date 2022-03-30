defmodule GraphCommons.Query do
  @moduledoc """
  Defines the Query Type
  """

  @type query_data :: String.t()
  @type query_file :: String.t()
  @type query_path :: String.t()
  @type query_type :: GraphCommons.query_type()
  @type query_uri :: String.t()

  @type t :: %__MODULE__{
          # user
          data: query_data,
          file: query_file,
          type: query_type,
          # system
          path: query_path,
          uri: query_uri
        }

  @storage_dir "#{:code.priv_dir(:graph_commons)}/storage"

  @enforce_keys ~w[data file type]a
  defstruct ~w[data file path type uri]a

  defguard is_graph_type(graph_type)
           when graph_type in [:dgraph, :native, :property, :rdf, :tinker]

  def new(query_data, query_file, graph_type) when is_graph_type(graph_type) do
    query_path = "#{@storage_dir}/#{graph_type}/graphs/#{query_file}"

    %__MODULE__{
      # user
      data: query_data,
      file: query_file,
      type: graph_type,
      # system
      path: query_path,
      uri: "file://" <> query_path
    }
  end

  def read_query(query_file, graph_type) when query_file != "" and is_graph_type(graph_type) do
    queries_dir = "#{@storage_dir}/#{graph_type}/queries"
    query_data = File.read!(queries_dir <> query_file)
    new(query_data, query_file, graph_type)
  end

  def write_query(query_data, query_file, graph_type)
      when query_data != "" and query_file != "" and is_graph_type(graph_type) do
    query_dir = "#{@storage_dir}/#{graph_type}/queries/"
    File.write!(query_dir <> query_file, query_data)
    new(query_data, query_file, graph_type)
  end

  def list_queries(graph_type, file_test \\ :exists?) do
    list_queries_dir("", graph_type, file_test)
  end

  def list_queries_dir(query_file, graph_type, file_test \\ :exists) do
    path = "#{@storage_dir}/#{graph_type}/queries/"

    (path <> query_file)
    |> File.ls!()
    |> do_filter(path, file_test)
    |> Enum.sort()
    |> Enum.map(fn f ->
      if File.dir?(path <> f) do
        "#{String.upcase(f)}"
      else
        f
      end
    end)
  end

  defp do_filter(files, path, file_test) do
    files
    |> Enum.filter(fn f ->
      case file_test do
        :dir? -> File.dir?(path <> f)
        :regular? -> File.regular?(path <> f)
        :exists? -> true
      end
    end)
  end

  defimpl Inspect, for: GraphCommons.Query do
    @slice 16
    @quote <<?">>

    def inspect(%GraphCommons.Query{} = query, _opts) do
      type = query.type
      file = @quote <> query.file <> @quote

      str =
        query.data
        |> String.replace("\n", "\\n")
        |> String.replace(@quote, "\\" <> @quote)
        |> String.slice(0, @slice)

      data =
        if String.length(str) < @slice do
          @quote <> str <> @quote
        else
          @quote <> str <> "..." <> @quote
        end

      "#GraphCommons.Query<type: #{type}, file: #{file}, data: #{data}"
    end
  end

  defmacro __using__(opts) do
    query_type = Keyword.get(opts, :query_type)
    query_module = Keyword.get(opts, :query_module)

    quote do
      ## Types

      @type query_file_test :: GraphCommons.Query.file_test()

      @type query_data :: GraphCommons.Query.graph_data()
      @type query_file :: GraphCommons.Query.graph_file()
      @type query_path :: GraphCommons.Query.graph_path()
      @type query_type :: GraphCommons.Query.graph_type()
      @type query_uri :: GraphCommons.Query.graph_uri()

      @type query_t :: GraphCommons.Query.t()

      ## Functions

      def query_service(), do: unquote(query_module)

      def list_queries(query_file_test \\ :exists?) do
        GraphCommons.Query.list_queries(unquote(query_type), query_file_test)
      end

      def list_queries_dir(dir, query_file_test \\ :exists?) do
        GraphCommons.Query.list_queries_dir(dir, unquote(query_type), query_file_test)
      end

      def new_query(query_data) do
        new_query(query_data, "")
      end

      def new_query(query_data, query_file) do
        GraphCommons.Query.new(query_data, query_file, unquote(query_type))
      end

      def read_query(query_file) do
        GraphCommons.Query.read_query(query_file, unquote(query_type))
      end

      def write_query(query_data, query_file) do
        GraphCommons.Query.write_query(query_data, query_file, unquote(query_type))
      end
    end
  end
end
