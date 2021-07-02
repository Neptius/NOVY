defmodule NovyData.Accounts.AuthProviderSession do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProvider, AuthProviderSession, User}

  schema "auth_provider_sessions" do
    field :state, :string
    field :verify, :boolean, default: false
    field :type, :string

    belongs_to :user, User
    belongs_to :auth_provider, AuthProvider

    timestamps()
  end

  def get_one_auth_provider_login_state(state, provider) do
    AuthProviderSession
    |> join(:inner, [aps], auth_provider in assoc(aps, :auth_provider))
    |> where([aps, ap], ap.label == ^provider)
    |> where([aps, ap], aps.state == ^state)
    |> where([aps, ap], aps.verify == false)
    |> where([aps, ap], aps.type == "login")
    |> preload([_, ap], auth_provider: ap)
    |> Repo.one()
  end

  def get_one_auth_provider_link_state(state, provider, user_id) do
    AuthProviderSession
    |> join(:inner, [aps], auth_provider in assoc(aps, :auth_provider))
    |> where([aps, ap], ap.label == ^provider)
    |> where([aps, ap], aps.state == ^state)
    |> where([aps, ap], aps.verify == false)
    |> where([aps, ap], aps.type == "link")
    |> where([aps, ap], aps.user_id == ^user_id)
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
    |> cast(attrs, [:state, :verify, :type, :user_id, :auth_provider_id])
    |> validate_required([:state, :verify, :type, :auth_provider_id])
  end
end
