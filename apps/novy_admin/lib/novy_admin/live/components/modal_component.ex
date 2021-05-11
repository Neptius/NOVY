defmodule NovyAdmin.ModalComponent do
  @moduledoc false

  use NovyAdmin, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed z-50 top-0 left-0 w-full h-full bg-black bg-opacity-40 overflow-x-hidden overflow-y-auto">

      <div id="<%= @id %>" class="phx-modal relative my-0 sm:my-16 max-w-screen-md w-full mx-auto bg-gray-700 shadow-lg sm:rounded-lg"
        phx-capture-click="close"
        phx-window-keydown="close"
        phx-key="escape"
        phx-target="#<%= @id %>"
        phx-page-loading>
          <div class="phx-modal-content p-4">
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
