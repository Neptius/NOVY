defmodule NovyData.Accounts.AuthProvider do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias NovyData.Repo
  alias NovyData.Accounts.{AuthProvider, AuthUser}

  schema "auth_providers" do
    field :label, :string
    field :method, :string
    field :active, :boolean, default: false

    field :client_id, :string
    field :client_secret, :string
    field :authorize_url, :string
    field :token_url, :string
    field :user_url, :string
    field :response_type, :string
    field :scope, :string

    field :user_path, :string
    field :user_id_path, :string
    field :user_pseudo_path, :string
    field :user_img_url, :string
    field :user_img_path, :string

    has_many :auth_users, AuthUser

    timestamps()
  end

  @doc """
  Gets a single auth provider.
  Raises `Ecto.NoResultsError` if the AuthProvider does not exist.
  ## Examples
      iex> get_auth_provider!(123)
      %AuthProvider{}
      iex> get_auth_provider!(456)
      ** (Ecto.NoResultsError)
  """
  def get_one_auth_provider(params) do
    filter(params)
    |> Repo.one()
  end

  @doc """
  Returns the list of auth providers.
  ## Examples
      iex> list_auth_providers()
      [%AuthProvider{}, ...]
  """
  def list_auth_providers do
    AuthProvider
    |> Repo.all()
  end


  @doc """
  Returns the list of auth providers.
  ## Examples
      iex> list_auth_providers()
      [%AuthProvider{}, ...]
  """
  def list_auth_providers(params) do
    filter(params)
    |> Repo.all()
  end

  @doc """
  Gets a single auth provider.
  Raises `Ecto.NoResultsError` if the AuthProvider does not exist.
  ## Examples
      iex> get_auth_provider!(123)
      %AuthProvider{}
      iex> get_auth_provider!(456)
      ** (Ecto.NoResultsError)
  """
  def get_auth_provider!(id), do: Repo.get!(AuthProvider, id)

  @doc """
  Gets a single auth provider.
  ## Examples
      iex> get_auth_provider(123)
      %AuthProvider{}
      iex> get_auth_provider(456)
      nil
  """
  def get_auth_provider(id), do: Repo.get(AuthProvider, id)

  @doc """
  Creates a auth provider.
  ## Examples
      iex> create_auth_provider(%{field: value})
      {:ok, %AuthProvider{}}
      iex> create_auth_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_auth_provider(attrs) do
    %AuthProvider{}
    |> AuthProvider.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a auth provider.
  ## Examples
      iex> update_auth_provider(auth_provider, %{field: new_value})
      {:ok, %AuthProvider{}}
      iex> update_auth_provider(auth_provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_auth_provider(%AuthProvider{} = auth_provider, attrs) do
    auth_provider
    |> AuthProvider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a auth provider.
  ## Examples
      iex> delete_auth_provider(auth_provider)
      {:ok, %AuthProvider{}}
      iex> delete_auth_provider(auth_provider)
      {:error, %Ecto.Changeset{}}
  """
  def delete_auth_provider(%AuthProvider{} = auth_provider) do
    Repo.delete(auth_provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking auth provider changes.
  ## Examples
      iex> change_auth_provider(auth_provider)
      %Ecto.Changeset{data: %AuthProvider{}}
  """
  def change_auth_provider(%AuthProvider{} = auth_provider, attrs \\ %{}) do
    AuthProvider.changeset(auth_provider, attrs)
  end

  def filter(params) do
    AuthProvider
    |> order_by(^filter_order_by(params["order_by"]))
    |> where(^filter_where(params))
  end


  def filter_order_by("label_asc"), do: [asc: :label]
  def filter_order_by("label_desc"), do: [desc: :label]

  def filter_order_by(_),
    do: []

  # 3. Change the authors clause inside reduce
  def filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"label", value}, dynamic ->
        dynamic([p], ^dynamic and p.label == ^value)

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end

  @doc false
  def changeset(auth_provider, attrs) do
    auth_provider
    |> cast(attrs, [
      :label,
      :method,
      :active,
      :client_id,
      :client_secret,
      :authorize_url,
      :token_url,
      :user_url,
      :response_type,
      :scope,
      :user_path,
      :user_id_path,
      :user_pseudo_path,
      :user_img_url,
      :user_img_path
    ])
    |> validate_required([
      :label,
      :method,
      :active,
      :client_id,
      :client_secret,
      :authorize_url,
      :token_url,
      :user_url,
      :response_type,
      :user_id_path,
      :user_pseudo_path,
      :user_img_path
    ])
  end
end
