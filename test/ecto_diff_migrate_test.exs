defmodule EctoDiffMigrateTest do
  use ExUnit.Case
  doctest EctoDiffMigrate

  alias Mix.Tasks.Ecto.{Create, Drop, Migrate}
  alias Mix.Tasks.Ecto.Diff

  setup do
    Drop.run(["-r", "EctoDiffMigrate.Repo", "-q"])
    Create.run(["-r", "EctoDiffMigrate.Repo", "-q"])

    on_exit(fn ->
      File.rm_rf(Path.join(Path.dirname(__ENV__.file), "../output/"))
    end)

    :ok
  end

  test "can diff multiple migrations" do
    Diff.Migrate.run([
      "--diff-output-dir",
      "output",
      "-r",
      "EctoDiffMigrate.Repo"
    ])

    assert File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200509175658"))
    assert File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200509171630"))
    assert File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200510145553"))
  end

  test "diff only down migrations" do
    Migrate.run(["-r", "EctoDiffMigrate.Repo", "--to", "20200509175658"])
    Diff.Migrate.run(["--diff-output-dir", "output", "-r", "EctoDiffMigrate.Repo"])

    refute File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200509175658"))
    refute File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200509171630"))
    assert File.exists?(Path.join(Path.dirname(__ENV__.file), "../output/20200510145553"))
  end

  test "expects --diff-output-dir option" do
    assert catch_exit(Diff.Migrate.run([])) == 1
  end
end
