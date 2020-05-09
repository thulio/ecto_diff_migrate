defmodule EctoDiffMigrate.Repo.Migrations.AddNewTable do
  use Ecto.Migration

  def change do
    create table(:table_2) do
    end
  end
end
