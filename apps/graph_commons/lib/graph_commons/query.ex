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

  @storage_dir ""

  @enforce_keys ~w[data file type]a
  defstruct ~w[data file path type uri]a

  defguard is_query_type(query_type) when query_type in [:dgraph, :native, :property, :rdf, :tinker]

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


end
