defmodule NovyAdmin.DashboardLive.Index do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyAdmin.Presence
  alias NovyAdmin.PubSub


  @presence "tutorial:presence"

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    if connected?(socket) do
      user = socket.assigns.current_user
      {:ok, _} =
        Presence.track(self(), "users:online", user.id, %{
          pseudo: user.pseudo,
          joined_at: inspect(System.system_time(:second))
        })

      Phoenix.PubSub.subscribe(PubSub, "users:online")

      {:ok, _} =
        Presence.track(self(), "users:count", user.id, %{
          pseudo: user.pseudo,
          joined_at: inspect(System.system_time(:second))
        })

      Phoenix.PubSub.subscribe(PubSub, "users:count")




    end


    {
      :ok,
      socket
      |> assign(:user, socket.assigns.current_user)
      |> assign(:users, %{})
      |> assign(:user_count, 0)
      |> handle_joins(Presence.list(@presence))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:auth_provider, nil)
  end

  # * Presence
  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    IO.inspect("handle_info")
    IO.inspect(diff.leaves)
    IO.inspect(diff.joins)
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)

      #|> push_event("points", %{points: new_points})}
    }
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end
end
