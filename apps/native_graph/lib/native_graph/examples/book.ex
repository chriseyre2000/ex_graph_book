defmodule NativeGraph.Examples.Book do
  def book(use_id? \\ true), do: do_books(false, use_id?)
  def books(use_id? \\ true), do: do_books(true, use_id?)

  defp do_books(all_books?, use_id?) do
    val = fn map -> if use_id?, do: map.id, else: map end

    # book1
    bk1 =
      val.(%{
        id: :adopting_elixir
      })

    # book2
    bk2 =
      val.(%{
        id: :graphql_apis
      })

    # book3
    bk3 =
      val.(%{
        id: :designing_elixir
      })

    # book4
    bk4 =
      val.(%{
        id: :graph_algorithms
      })

    # build graph
    g =
      Graph.new(type: :directed)
      |> Graph.add_vertex("bk1", "book")

    g =
      if all_books? do
        g
        |> Graph.add_vertex("bk2", "book")
        |> Graph.add_vertex("bk3", "book")
        |> Graph.add_vertex("bk4", "book")
      else
        g
      end

    g
  end
end
