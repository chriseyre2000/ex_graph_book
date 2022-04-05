defmodule ExGraphBook.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      apps: [
        :d_graph,
        :graph_commons,
        :graph_compute,
        :native_graph,
        :property_graph,
        :rdf_graph,
        :tinker_graph
      ],
      apps_path: "apps",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:hackney, "~> 1.0"},]
  end

  defp aliases do
    [
      test_graph_commons: "cmd --app graph_commons mix test --color"
    ]
  end
end
