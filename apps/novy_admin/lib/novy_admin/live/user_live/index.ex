defmodule NovyAdmin.UserLive.Index do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyData.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, users: list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User ##{id}")
    |> assign(:user, User.get_user!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    # user = User.get_user!(id)
    # {:ok, _} = User.delete_user(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  defp list_users do
    User.list_users()
  end
end
