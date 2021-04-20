defmodule NovyAdmin.LiveHelpers do
  @moduledoc false

  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView

  alias NovyData.Accounts

  @doc """
  Renders a component inside the `NovyAdmin.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, NovyAdmin.AuthProviderLive.FormComponent,
        id: @auth_provider.id || :new,
        action: @live_action,
        auth_provider: @auth_provider,
        return_to: Routes.auth_provider_index_path(@socket, :index) %>
  """
  def live_modal(_socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, NovyAdmin.ModalComponent, modal_opts)
  end

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
