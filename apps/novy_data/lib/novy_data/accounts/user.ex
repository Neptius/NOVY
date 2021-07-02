defmodule NovyData.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProviderSession, AuthUser, User, UserToken}

  schema "users" do
    field :pseudo, :string

    has_many :auth_users, AuthUser, on_delete: :delete_all
    has_many :user_tokens, UserToken, on_delete: :delete_all
    has_many :auth_provider_sessions, AuthProviderSession, on_delete: :delete_all

    timestamps()
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id), do: Repo.get!(User, id)

  def list_users do
    User
    |> Repo.all()
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def create_user_with_auth_user(attrs, %AuthUser{} = auth_user) do
    %User{}
    |> User.changeset(attrs)
    |> put_assoc(:auth_users, [auth_user])
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:pseudo])
    |> validate_required([:pseudo])
  end
end
