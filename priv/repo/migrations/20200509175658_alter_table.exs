defmodule EctoDiffMigrate.Repo.Migrations.AlterTable do
  use Ecto.Migration

  def change do
    alter table(:table) do
      add(:column, :string)
    end
  end
end
