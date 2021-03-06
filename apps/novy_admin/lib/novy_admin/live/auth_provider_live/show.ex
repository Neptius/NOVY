defmodule NovyAdmin.AuthProviderLive.Show do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyData.Accounts.AuthProvider

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, id))
     |> assign(:auth_provider, AuthProvider.get_auth_provider!(id))}
  end

  defp page_title(:show, id), do: "Show Auth provider ##{id}"
  defp page_title(:edit, id), do: "Edit Auth provider ##{id}"
end
