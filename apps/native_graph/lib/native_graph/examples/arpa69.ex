defmodule NativeGraph.Examples.Arpa69 do
  def arpa69 do
    ## GRAPH
    g = Graph.new(type: :undirected)

    # Site UCLA
    g =
      g |> Graph.add_vertex(:ucla, "UCLA")
        |> Graph.add_vertex(:ucla_h1, "SIGMA7")
        |> Graph.add_edge(:ucla_h1, :ucla)

    # Site UCSB
    g =
      g |> Graph.add_vertex(:ucsb, "UCSB")
        |> Graph.add_vertex(:ucsb_h1, "360")
        |> Graph.add_edge(:ucsb_h1, :ucsb)

    # Site SRI
    g =
      g |> Graph.add_vertex(:sri, "SRI")
        |> Graph.add_vertex(:sri_h1, "940")
        |> Graph.add_edge(:sri_h1, :sri)

    # Site UTAH
    g =
      g |> Graph.add_vertex(:utah, "UTAH")
        |> Graph.add_vertex(:utah_h1, "PDP-10")
        |> Graph.add_edge(:utah_h1, :utah)

    ## NETWORK (3+1=4)
    g =
      g
      |> Graph.add_edge(:ucla, :ucsb)
      |> Graph.add_edge(:ucsb, :sri)
      |> Graph.add_edge(:sri, :ucla)
      |> Graph.add_edge(:sri, :utah)

    g =
      g
      |> Graph.edges()
      |> Enum.reduce(g, fn %{v1: v1, v2: v2, label: label}, g ->
        Graph.add_edge(g, v2, v1, label: label)
      end)
    g
  end
end
