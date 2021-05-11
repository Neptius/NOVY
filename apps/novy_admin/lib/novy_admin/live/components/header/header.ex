defmodule NovyAdmin.AdminComponent.Header do
  @moduledoc false

  use NovyAdmin, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end
