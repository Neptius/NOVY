defmodule NovyAdmin.ModalComponent do
  @moduledoc false

  use NovyAdmin, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed z-50 top-0 left-0 w-full h-full bg-indigo-800">

      <div id="<%= @id %>" class="phx-modal max-w-screen-md w-full mx-auto"
        phx-capture-click="close"
        phx-window-keydown="close"
        phx-key="escape"
        phx-target="#<%= @id %>"
        phx-page-loading>
          <div class="phx-modal-content">
            <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close" %>
            <%= live_component @socket, @component, @opts %>
          </div>
      </div>

    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
