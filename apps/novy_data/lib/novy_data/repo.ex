defmodule NovyData.Repo do
  use Ecto.Repo,
    otp_app: :novy_data,
    adapter: Ecto.Adapters.Postgres
end
