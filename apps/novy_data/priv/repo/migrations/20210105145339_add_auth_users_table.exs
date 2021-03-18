defmodule NovyData.Repo.Migrations.AddAuthUsersTable do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :auth_provider_user_id, :string
      add :auth_provider_user_pseudo, :string
      add :auth_provider_user_img, :string
      add :user_data, :map

      add :user_id, references(:users), null: false
      add :auth_provider_id, references(:auth_providers), null: false

      timestamps()
    end
  end
end
