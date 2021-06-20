defmodule NovySite.HomeLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyData.Accounts.AuthUser

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    auth_users =
      AuthUser.get_auth_users_with_auth_providers_by_user_id(socket.assigns.current_user.id)

    {:ok, assign(socket, auth_users: auth_users)}
  end
end
