defmodule GraphCommons do
  @moduledoc """
  Documentation for `GraphCommons`.
  """

  @typedoc "Types for graph storage"
  @type base_type :: :dgraph | :native | :property | :rdf | :tinker
  @type graph_type :: base_type
  @type query_type :: base_type

  @typedoc "Type for testing file types"
  @type file_test :: :dir? | :regular? | :exists?

end
