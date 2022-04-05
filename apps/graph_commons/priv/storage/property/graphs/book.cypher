// Book 1
CREATE
  (bk1:Book {
    id: "adopting_elixir",
    iri: "urn:isbn:978-1-68050-252-7",
    date: "2018-03-14",
    format: "Paper",
    title: "Adopting Elixir"
  }),
  (bk1_au1:Author{
    id: "ben_marx",
    iri: "https://twitter.com/bmarx",
    name: "Ben Marx"
  }),
  (bk1_au2:Author{
    id: "jose_valim",
    iri: "https://twitter.com/josevalim",
    name: "Jose Valim"
  }),
  (bk1_au3:Author{
    id: "bruce_tate",
    iri: "https://twitter.com/redrapids",
    name: "Bruce Tate"
  }),
  (bk1_pub:Publisher{
    id: "pragmatic",
    iri: "https://pragpram.com",
    name: "The Pragmatic Bookshelf"
  })

  CREATE
  (bk1)-[:AUTHOR {role: "first author"}]->(bk1_au1),
  (bk1)-[:AUTHOR {role: "second author"}]->(bk1_au2),
  (bk1)-[:AUTHOR {role: "third author"}]->(bk1_au3),
  (bk1)-[:PUBLISHER]->(bk1_pub),
  (bk1_pub)-[:BOOK]->(bk1)
  ;