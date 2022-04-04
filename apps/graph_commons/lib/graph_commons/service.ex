defmodule GraphCommons.Service do
  @optional_callbacks graph_info: 0
  @optional_callbacks query_graph: 2
  @optional_callbacks query_graph!: 2

  ## GRAPH
  @callback graph_create(GraphCommons.Graph.t()) :: any()
  @callback graph_delete() :: any()
  @callback graph_info() :: any()
  @callback graph_read() :: any()
  @callback graph_update(GraphCommons.Graph.t()) :: any()

  ## QUERY
  @callback query_graph(GraphCommons.Query.t()) :: any()
  @callback query_graph!(GraphCommons.Query.t()) :: any()
  @callback query_graph(GraphCommons.Query.t(), map()) :: any()
  @callback query_graph!(GraphCommons.Query.t(), map()) :: any()

  defmodule GraphInfo do
    defstruct ~w[type file num_nodes num_edges stats label]a
  end
end
