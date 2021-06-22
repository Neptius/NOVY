defmodule NovySite.LiveHelpers do
  @moduledoc false

  import Phoenix.LiveView

  alias NovyData.Accounts

  def assign_defaults(%{"user_token" => user_token}, socket) do
    socket =
      socket
      |> prepare_assign()
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/login")
    end
  end

  def assign_defaults(_conn, socket) do
    socket
    |> prepare_assign()
    |> assign(:current_user, nil)
  end

  def prepare_assign(socket) do
    assign(socket, static_changed?: static_changed?(socket))
  end
end
