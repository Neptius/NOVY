defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyData.Accounts.AuthProvider
  alias NovyData.AuthService

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
  def handle_event("delete_user", _params, socket) do
    IO.inspect("YESS")
    {:noreply, socket}
  end
end
