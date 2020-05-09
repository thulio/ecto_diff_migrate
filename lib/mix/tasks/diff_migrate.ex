defmodule Mix.Tasks.Ecto.Diff.Migrate do
  use Mix.Task

  @shortdoc "Hello world"
  @moduledoc """
  Hello World
  """

  @switches [
    diff_output_dir: :string
  ]
  @aliases [
    r: :repo
  ]

  @impl true
  def run(args) do
    {opts, _} = OptionParser.parse!(args, switches: @switches, aliases: @aliases)

    unless opts[:diff_output_dir] do
      IO.puts("Error: --diff-output-dir is required")
      exit(1)
    end

    ecto_args = OptionParser.to_argv(Keyword.delete(opts, :diff_output_dir))

    EctoDiffMigrate.diff_migrate(opts[:diff_output_dir], ecto_args)
  end
end
