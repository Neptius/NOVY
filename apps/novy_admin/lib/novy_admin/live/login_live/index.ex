defmodule NovyAdmin.LoginLive.Index do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyData.Accounts.AuthProvider
  alias NovyData.AuthService

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    auth_providers = AuthProvider.list_auth_providers()
    {:ok, assign(socket, page_title: "Connexion", auth_providers: auth_providers)}
  end

  @impl true
  def handle_event("init_auth", %{"provider" => provider}, socket) do
    case AuthService.init_auth(provider) do
      {:ok, url} -> {:noreply, redirect(socket, external: url)}
      {:error, _} -> {:noreply, socket}
    end
  end

  @impl true
  def handle_params(_params, url, socket) do
    uri = URI.parse(url)
    redirect_url = "#{uri.scheme}://#{uri.authority}"

    IO.inspect(redirect_url)
    {:ok, assign(socket, redirect_url: redirect_url)}
  end
end
