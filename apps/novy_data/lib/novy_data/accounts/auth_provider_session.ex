defmodule NovyData.Accounts.AuthProviderSession do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProvider, AuthProviderSession}

  schema "auth_provider_sessions" do
    field :state, :string
    field :verify, :boolean, default: false

    belongs_to :auth_provider, AuthProvider

    timestamps()
  end

  def get_one_auth_provider_session_by_state_and_provider(state, provider) do
    AuthProviderSession
    |> join(:inner, [aps], auth_provider in assoc(aps, :auth_provider))
    |> where([aps, ap], ap.label == ^provider)
    |> where([aps, ap], aps.state == ^state)
    |> where([aps, ap], aps.verify == false)
    |> preload([_, ap], auth_provider: ap)
    |> Repo.one()
  end

  def create_auth_provider_session(attrs) do
    %AuthProviderSession{}
    |> AuthProviderSession.changeset(attrs)
    |> Repo.insert()
  end

  def update_auth_provider_session(%AuthProviderSession{} = auth_provider_session, attrs) do
    auth_provider_session
    |> AuthProviderSession.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def changeset(auth_provider_session, attrs) do
    auth_provider_session
    |> cast(attrs, [:state, :verify, :auth_provider_id])
    |> validate_required([:state, :verify, :auth_provider_id])
  end
end
