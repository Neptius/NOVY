defmodule NovyData.Accounts.AuthUser do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProvider, AuthUser, User}

  schema "auth_users" do
    field :auth_provider_user_id, :string
    field :auth_provider_user_pseudo, :string
    field :auth_provider_user_img, :string
    field :user_data, :map

    belongs_to :user, User
    belongs_to :auth_provider, AuthProvider

    timestamps()
  end

  def get_auth_users_with_auth_providers_by_user_id(user_id) do
    AuthUser
    |> where([au], au.user_id == ^user_id)
    |> join(:inner, [au], auth_provider in assoc(au, :auth_provider))
    |> preload([_, ap], auth_provider: ap)
    |> Repo.all()
  end

  def get_exist_auth_user(label, auth_provider_user_id) do
    AuthUser
    |> join(:inner, [au], auth_provider in assoc(au, :auth_provider))
    |> where([au, ap], ap.label == ^label)
    |> where([au, ap], au.auth_provider_user_id == ^auth_provider_user_id)
    |> preload([_, ap], auth_provider: ap)
    |> Repo.one()
  end

  def update_auth_user(%AuthUser{} = auth_user, attrs) do
    auth_user
    |> AuthUser.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def changeset(auth_user, attrs) do
    auth_user
    |> cast(attrs, [
      :auth_provider_user_id,
      :auth_provider_user_pseudo,
      :auth_provider_user_img,
      :user_data
    ])
    |> validate_required([
      :auth_provider_user_id,
      :auth_provider_user_pseudo,
      :auth_provider_user_img,
      :user_data
    ])
  end
end
