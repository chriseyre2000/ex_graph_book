defmodule GraphCommons.Query do
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

  defguard is_query_type(query_type)
           when query_type in [:dgraph, :native, :property, :rdf, :tinker]

  def new(query_data, query_file, query_type) when is_query_type(query_type) do
    query_path = "#{@storage_dir}/#{query_type}/graphs/#{query_file}"

    %__MODULE__{
      # user
      data: query_data,
      file: query_file,
      type: query_type,
      # system
      path: query_path,
      uri: "file://" <> query_path
    }
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
end
