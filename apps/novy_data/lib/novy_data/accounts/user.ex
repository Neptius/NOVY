defmodule NovyData.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProvider, AuthUser, User}

  schema "users" do
    field :pseudo, :string

    has_many :auth_users, AuthUser

    timestamps()
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id), do: Repo.get!(User, id)

  def create_user_with_auth_user(attrs, %AuthUser{} = auth_user) do
    %User{}
    |> User.changeset(attrs)
    |> put_assoc(:auth_users, [auth_user])
    |> Repo.insert()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:pseudo])
    |> validate_required([:pseudo])
  end
end
