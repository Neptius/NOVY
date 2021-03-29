defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovySite.Presence
  alias NovySite.PubSub

  @presence "novy:presence"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      user = session["current_user"]

      {:ok, _} =
        Presence.track(self(), @presence, user[:id], %{
          name: user[:name],
          joined_at: :os.system_time(:seconds)
        })

      Phoenix.PubSub.subscribe(PubSub, @presence)
    end

    socket = assign_defaults(session, socket)

    {
      :ok,
      socket
      |> assign(:current_user, session["current_user"])
      |> assign(:users, %{})
      |> handle_joins(Presence.list(@presence))
    }
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
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
