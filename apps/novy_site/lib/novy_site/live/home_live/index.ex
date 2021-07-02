defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyData.Accounts.AuthProvider
  alias NovyData.AuthService
  alias NovyData.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    auth_providers =
      AuthProvider.get_auth_provider_with_auth_users_by_user_id(socket.assigns.current_user.id)

    {:ok, assign(socket, auth_providers: auth_providers)}
  end

  @impl true
  def handle_event(
        "init_auth_link",
        %{"provider" => provider},
        %{:assigns => %{:redirect_host => redirect_host}} = socket
      ) do
    case AuthService.init_link(provider, redirect_host, socket.assigns.current_user.id) do
      {:ok, url} ->
        {:noreply, redirect(socket, external: url)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(_params, url, socket) do
    uri = URI.parse(url)
    redirect_host = "#{uri.scheme}://#{uri.authority}"
    {:noreply, assign(socket, redirect_host: redirect_host)}
  end

  @impl true
  def handle_event("unlink_auth", %{"provider" => _provider}, socket) do
    {:noreply, socket}
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = User.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> User.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case User.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
