defmodule NovyAdmin.AuthProviderLive.Show do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyData.Accounts.AuthProvider

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:auth_provider, AuthProvider.get_auth_provider!(id))}
  end

  defp page_title(:show), do: "Show Auth provider"
  defp page_title(:edit), do: "Edit Auth provider"
end
