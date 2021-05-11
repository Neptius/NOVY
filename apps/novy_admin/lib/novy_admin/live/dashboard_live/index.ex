defmodule NovyAdmin.DashboardLive.Index do
  @moduledoc false

  use NovyAdmin, :live_view

  alias NovyAdmin.Presence
  alias NovyAdmin.PubSub

  @presence_user "users:online"
  @presence_guest "users:guest"

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    if connected?(socket) do
      user = socket.assigns.current_user

      {:ok, _} =
        Presence.track(self(), @presence_user, user.id, %{
          pseudo: user.pseudo,
          joined_at: inspect(System.system_time(:second))
        })

      Phoenix.PubSub.subscribe(PubSub, @presence_user)
      Phoenix.PubSub.subscribe(PubSub, @presence_guest)
    end

    {
      :ok,
      socket
      |> assign(:user, socket.assigns.current_user)
      |> assign(:users, %{})
      |> assign(:visitors, 0)
      |> handle_joins(Presence.list(@presence_user))
      |> handle_guest_joins(Presence.list(@presence_guest))
      |> push_event("points", %{points: 0 + map_size(Presence.list(@presence_guest))})
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
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff, topic: @presence_user},
        socket
      ) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
    }
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff, topic: @presence_guest},
        socket
      ) do
    {
      :noreply,
      socket
      |> handle_guest_leaves(diff.leaves)
      |> handle_guest_joins(diff.joins)
      |> push_event("points", %{
        points: socket.assigns.visitors + map_size(diff.joins) - map_size(diff.leaves)
      })
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

  defp handle_guest_joins(socket, joins) do
    assign(socket, :visitors, socket.assigns.visitors + map_size(joins))
  end

  defp handle_guest_leaves(socket, leaves) do
    assign(socket, :visitors, socket.assigns.visitors - map_size(leaves))
  end
end
