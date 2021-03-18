defmodule NovyData.Repo.Migrations.AddAuthProviderSessionsTable do
  use Ecto.Migration

  def change do
    create table(:auth_provider_sessions) do
      add :auth_provider_id, references(:auth_providers), null: false

      add :state, :string
      add :verify, :boolean, default: false, null: false

      timestamps()
    end
  end
end
