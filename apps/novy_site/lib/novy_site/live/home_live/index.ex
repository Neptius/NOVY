defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyAdmin.Presence

  @presence_guest "users:guest"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      {:ok, _} = Presence.track(self(), @presence_guest, UUID.uuid4(), %{})
    end

    socket = assign_defaults(session, socket)

    {:ok, socket}
  end
end
