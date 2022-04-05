defmodule PropertyGraph do
  @moduledoc """
  Documentation for `PropertyGraph`.
  """
  use GraphCommons.Graph, graph_type: :property, graph_module: __MODULE__
  use GraphCommons.Query, query_type: :property, query_module: __MODULE__


  @doc """
  Hello world.

  ## Examples

      iex> PropertyGraph.hello()
      :world

  """
  def hello do
    :world
  end

  def query_graph!(%GraphCommons.Query{} = query) do
    PropertyGraph.Service.query_graph!(query)
  end


end
