defmodule NovyData.Repo.Migrations.RemoveRedirectUrlFromAuthProvider do
  use Ecto.Migration

  def up do
    alter table(:auth_providers) do
      remove :redirect_url
    end
  end

  def down do
    alter table(:auth_providers) do
      add :redirect_url, :string
    end
  end
end
