defmodule RDFGraph.Vocab do
  use RDF.Vocabulary.Namespace

  defvocab(DC,
    base_iri: "http://purl.org/dc/elements/1.1/",
    terms: ~w[
      controller coverage creator date description format
      identifier language publisher relation rights source
      subject title type
    ]
  )

end
