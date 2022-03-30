defmodule NativeGraph do
  @moduledoc """
  Documentation for `NativeGraph`.
  """
  use GraphCommons.Graph, graph_type: :native, graph_module: __MODULE__
  use GraphCommons.Query, query_type: :native, query_module: __MODULE__

  defdelegate write_image(arg), to: NativeGraph.Format, as: :to_png
  defdelegate write_image(arg1, arg2), to: NativeGraph.Format, as: :to_png

  # More work is needed here
  defdelegate to_dot(arg), to: Graph.Serializers.DOT, as: :serialize
  # defdelegate to_dot!(arg), to: Graph.Serializers.DOT, as: :serialize!

  defdelegate random_graph(arg), to: NativeGraph.Builder, as: :random_graph
end
