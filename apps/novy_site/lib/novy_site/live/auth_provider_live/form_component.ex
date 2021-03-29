defmodule NovySite.AuthProviderLive.FormComponent do
  @moduledoc false

  use NovySite, :live_component

  alias NovyData.Accounts.AuthProvider

  @impl true
  def update(%{auth_provider: auth_provider} = assigns, socket) do
    changeset = AuthProvider.change_auth_provider(auth_provider)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"auth_provider" => auth_provider_params}, socket) do
    changeset =
      socket.assigns.auth_provider
      |> AuthProvider.change_auth_provider(auth_provider_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"auth_provider" => auth_provider_params}, socket) do
    save_auth_provider(socket, socket.assigns.action, auth_provider_params)
  end

  defp save_auth_provider(socket, :edit, auth_provider_params) do
    case AuthProvider.update_auth_provider(socket.assigns.auth_provider, auth_provider_params) do
      {:ok, _auth_provider} ->
        {:noreply,
         socket
         |> put_flash(:info, "Auth provider updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_auth_provider(socket, :new, auth_provider_params) do
    case AuthProvider.create_auth_provider(auth_provider_params) do
      {:ok, _auth_provider} ->
        {:noreply,
         socket
         |> put_flash(:info, "Auth provider created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
