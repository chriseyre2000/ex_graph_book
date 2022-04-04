defmodule GraphCommons.Utils do
  def cypher!(query_string), do: to_query_graph!(PropertyGraph, query_string)

  defguard is_module(graph_module) when graph_module in [DGraph, NativeGraph, PropertyGraph, RDFGraph]

  defp to_query_graph!(graph_module, query_string) when is_module(graph_module) do
    query_string
    |> graph_module.new_query()
    |> graph_module.query_graph!()
  end

  defmacro graph_service(graph_module) do
    quote do
      # Unimport everything
      import DGraph, only: []
      import NativeGraph, only: []
      import PropertyGraph, only: []
      import RDFGraph, only: []
      import TinkerGraph, only: []

      # Import the one we need
      import unquote(graph_module)
    end
  end
end
