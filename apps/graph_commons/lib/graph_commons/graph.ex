defmodule GraphCommons.Graph do
  @moduledoc """
  Defines the Graph Type
  """

  @type graph_data :: String.t()
  @type graph_file :: String.t()
  @type graph_path :: String.t()
  @type graph_type :: GraphCommons.graph_type()
  @type graph_uri :: String.t()

  @type file_test :: GraphCommons.file_test()

  @type t :: %__MODULE__{
          # user
          data: graph_data,
          file: graph_file,
          type: graph_type,
          # system
          path: graph_path,
          uri: graph_uri
        }

  @storage_dir "#{:code.priv_dir(:graph_commons)}/storage"

  @enforce_keys ~w[data file type]a
  defstruct ~w[data file path type uri]a

  defguard is_graph_type(graph_type)
           when graph_type in [:dgraph, :native, :property, :rdf, :tinker]

  def new(graph_data, graph_file, graph_type) when is_graph_type(graph_type) do
    graph_path = "#{@storage_dir}/#{graph_type}/graphs/#{graph_file}"

    %__MODULE__{
      # user
      data: graph_data,
      file: graph_file,
      type: graph_type,
      # system
      path: graph_path,
      uri: "file://" <> graph_path
    }
  end

  def read_graph(graph_file, graph_type) when graph_file != "" and is_graph_type(graph_type) do
    graphs_dir = "#{@storage_dir}/#{graph_type}/graphs/"
    graph_data = File.read!(graphs_dir <> graph_file)
    new(graph_data, graph_file, graph_type)
  end

  def write_graph(graph_data, graph_file, graph_type)
      when graph_data != "" and graph_file != "" and is_graph_type(graph_type) do
    graphs_dir = "#{@storage_dir}/#{graph_type}/graphs/"
    File.write!(graphs_dir <> graph_file, graph_data)
    new(graph_data, graph_file, graph_type)
  end

  def list_graphs(graph_type, file_test \\ :exists?) do
    list_graphs_dir("", graph_type, file_test)
  end

  def list_graphs_dir(graph_file, graph_type, file_test \\ :exists) do
    path = "#{@storage_dir}/#{graph_type}/graphs/"

    (path <> graph_file)
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

  defimpl Inspect, for: GraphCommons.Graph do
    @slice 16
    @quote <<?">>

    def inspect(%GraphCommons.Graph{} = graph, _opts) do
      type = graph.type
      file = @quote <> graph.file <> @quote

      str =
        graph.data
        |> String.replace("\n", "\\n")
        |> String.replace(@quote, "\\" <> @quote)
        |> String.slice(0, @slice)

      data =
        if String.length(str) < @slice do
          @quote <> str <> @quote
        else
          @quote <> str <> "..." <> @quote
        end

      "#GraphCommons.Graph <type: #{type}, file: #{file}, data: #{data}"
    end
  end

  defmacro __using__(opts) do
    graph_type = Keyword.get(opts, :graph_type)
    graph_module = Keyword.get(opts, :graph_module)

    quote do
      def graph_module, do: unquote(graph_module) |> GraphCommons.Utils.graph_service()

      ## Types

      @type graph_file_test :: GraphCommons.Graph.file_test()

      @type graph_data :: GraphCommons.Graph.graph_data()
      @type graph_file :: GraphCommons.Graph.graph_file()
      @type graph_path :: GraphCommons.Graph.graph_path()
      @type graph_type :: GraphCommons.Graph.graph_type()
      @type graph_uri :: GraphCommons.Graph.graph_uri()

      @type graph_t :: GraphCommons.Graph.t()

      ## Functions

      def graph_service(), do: unquote(graph_module)

      def list_graphs(graph_file_test \\ :exists?) do
        GraphCommons.Graph.list_graphs(
          unquote(graph_type),
          graph_file_test
        )
      end

      def list_graphs_dir(dir, graph_file_test \\ :exists?) do
        GraphCommons.Graph.list_graphs_dir(
          dir,
          unquote(graph_type),
          graph_file_test
        )
      end

      def new_graph(graph_data) do
        new_graph(graph_data, "")
      end

      def new_graph(graph_data, graph_file) do
        GraphCommons.Graph.new(graph_data, graph_file, unquote(graph_type))
      end

      def read_graph(graph_file) do
        GraphCommons.Graph.read_graph(graph_file, unquote(graph_type))
      end

      def write_graph(graph_data, graph_file) do
        GraphCommons.Graph.write_graph(graph_data, graph_file, unquote(graph_type))
      end
    end
  end
end
