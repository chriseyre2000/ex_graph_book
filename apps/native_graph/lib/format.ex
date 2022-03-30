defmodule NativeGraph.Format do
  @graph_images_dir GraphCommons.storage_dir() <> "native"
  @binary_dir "/usr/local/bin/"

  @type layout :: :dot | :neato | :twopi | :circo | :fdp | :sfdp | :patchwork | :osage

  def to_png(%GraphCommons.Graph{} = graph, layout \\ :dot) do
    layout_cmd = Path.join(@binary_dir, Atom.to_string(layout))

    dot_file = graph.path
    png_file = @graph_images_dir <> Path.basename(dot_file, ".dot") <> ".png"

    with {_, 0} <- System.cmd(layout_cmd, ["-T", "png", dot_file, "-o", png_file]) do
      {:ok, Path.basename(png_file)}
    end
  end

  defdelegate write_image(arg), to: NativeGraph.Format, as: :to_png
  defdelegate write_image(arg1, arg2), to: NativeGraph.Format, as: :to_png
end
