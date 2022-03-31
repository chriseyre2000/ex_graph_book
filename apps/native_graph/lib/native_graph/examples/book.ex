defmodule NativeGraph.Examples.Book do
  def book(use_id? \\ true), do: do_books(false, use_id?)
  def books(use_id? \\ true), do: do_books(true, use_id?)

  defp do_books(all_books?, use_id?) do
    val = fn map -> if use_id?, do: map.id, else: map end

    # book1
    bk1 =
      val.(%{
        id: :adopting_elixir,
        iri: "urn:isbn:978-1-68050-252-7",
        date: "2018-03-14",
        format: "Paper",
        title: "Adopting Elixir"
      })

    bk1_au1 =
        val.(%{
          id: :ben_marx,
          iri: "https://twitter.com/bgmarx",
          name: "Ben Marx"
        })
    bk1_au2 =
        val.(%{
          id: :jose_valim,
          iri: "https://twitter.com/josevalim",
          name: "Jose Valim"
        })
    bk1_au3 =
        val.(%{
          id: :bruce_tate,
          iri: "https://twitter.com/redrapids",
          name: "Bruce Tate"
        })

    bk1_pub =
      val.(%{
        id: :pragmatic,
        iri: "https://pragmatic.com/",
        name: "The Pragmatic Bookshelf"
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
      |> Graph.add_vertex(bk1, "book")
      |> Graph.add_vertex(bk1_au1, "Author")
      |> Graph.add_vertex(bk1_au2, "Author")
      |> Graph.add_vertex(bk1_au3, "Author")
      |> Graph.add_vertex(bk1_pub, "Publisher")
      |> Graph.add_edge(bk1_pub, bk1, label: "BOOK")
      |> Graph.add_edge(bk1, bk1_au1, label: "AUTHOR")
      |> Graph.add_edge(bk1, bk1_au2, label: "AUTHOR")
      |> Graph.add_edge(bk1, bk1_au3, label: "AUTHOR")
      |> Graph.add_edge(bk1, bk1_pub, label: "PUBLISHER")

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
