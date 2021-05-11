defmodule NovySite.DefaultComponent.TrackUser do
  @moduledoc false

  use NovySite, :live_component

  alias NovyAdmin.Presence

  @presence_guest "users:guest"

  @impl true
  def render(assigns) do
    ~L"""
    <div/>
    """
  end

  @impl true
  def mount(socket) do
    if connected?(socket) do
      {:ok, _} = Presence.track(self(), @presence_guest, UUID.uuid4(), %{})
    end
    {:ok, socket}
  end
end
