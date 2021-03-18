defmodule NovyData.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :pseudo, :string

      timestamps()
    end
  end
end
