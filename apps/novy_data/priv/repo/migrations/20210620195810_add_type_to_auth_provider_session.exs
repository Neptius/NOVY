defmodule NovyData.Repo.Migrations.AddTypeToAuthProviderSession do
  use Ecto.Migration

  def change do
    alter table(:auth_provider_sessions) do
      add :type, :string
      add :user_id, references(:users)
    end
  end
end
