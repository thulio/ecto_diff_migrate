defmodule EctoDiffMigrate do
  @moduledoc """
  `EctoDiffMigrate` keeps track of database structure changes
  through diff files.

  Diff files make easier for a developer or database
  administrator see and evaluate those changes before aplying them
  to a production database.
  """
  alias EctoDiffMigrate.TaskOutput
  alias Mix.Tasks.Ecto.{Create, Dump, Migrate, Migrations}

  @spec diff_migrate(Path.t(), Keyword.t()) :: :ok | {:error, any()}
  @doc """
  Scans current down migrations and migrates them
  while keeping a diff for each migration
  """
  def diff_migrate(output_dir, ecto_args) do
    {initial_diff, current_diff} = setup(output_dir, ecto_args)

    TaskOutput.get()
    |> String.split("\n")
    |> Enum.each(fn migration ->
      if String.contains?(migration, "down") do
        do_migrate(output_dir, initial_diff, current_diff, migration, ecto_args)
      end
    end)

    Temp.cleanup()
  end

  defp do_migrate(output_dir, initial_diff, current_diff, migration, ecto_args) do
    [_, _state, version, _name | _] = String.split(migration, ~r/\s+/)

    Dump.run(ecto_args ++ ["-d", initial_diff, "--quiet"])
    Migrate.run(["--to", version, "--quiet"])
    Dump.run(ecto_args ++ ["-d", current_diff, "--quiet"])

    diff_output = diff(initial_diff, current_diff)

    output_dir
    |> Path.join(version)
    |> File.write!(diff_output)

    File.write!(initial_diff, File.read!(current_diff))
  end

  defp setup(output_dir, ecto_args) do
    Temp.track!()
    {:ok, _pid} = TaskOutput.start_link([])

    {_fd, initial_diff} = Temp.open!("initial")
    {_fd, current_diff} = Temp.open!("current")

    File.mkdir_p!(output_dir)
    Create.run(ecto_args)
    get_pending_migrations(ecto_args)

    {initial_diff, current_diff}
  end

  defp get_pending_migrations(ecto_args) do
    Migrations.run(ecto_args, &Ecto.Migrator.migrations/2, &TaskOutput.add/1)
  end

  defp diff(from, to) do
    {output, 1} = System.cmd("diff", [from, to])

    output
  end
end
