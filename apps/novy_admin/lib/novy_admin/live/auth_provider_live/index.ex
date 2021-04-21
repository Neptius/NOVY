defmodule NovyAdmin.AuthProviderLive.Index do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyData.Accounts.AuthProvider

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, :auth_providers, list_auth_providers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Auth provider")
    |> assign(:auth_provider, AuthProvider.get_auth_provider!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Auth provider")
    |> assign(:auth_provider, %AuthProvider{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Auth providers")
    |> assign(:auth_provider, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    auth_provider = AuthProvider.get_auth_provider!(id)
    {:ok, _} = AuthProvider.delete_auth_provider(auth_provider)

    {:noreply, assign(socket, :auth_providers, list_auth_providers())}
  end

  defp list_auth_providers do
    AuthProvider.list_auth_providers()
  end
end
