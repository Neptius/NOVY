defmodule NovySite.Components.OnlineUsers do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <h2>Users online:</h2>
      <%= for {user_id, user} <- @users do %>
        <%= if user_id == @current_user[:id] do %>
          <span class="text-xs bg-green-200 rounded px-2 py-1"><%= user[:name] %> (me)</span>
        <% else %>
          <span class="text-xs bg-blue-200 rounded px-2 py-1"><%= user[:name] %></span>
        <% end %>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
