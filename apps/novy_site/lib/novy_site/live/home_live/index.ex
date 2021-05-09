defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end
end
