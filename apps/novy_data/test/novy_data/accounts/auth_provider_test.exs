defmodule NovyData.Accounts.AuthProviderTest do
  @moduledoc false

  use NovyData.DataCase, async: true

  alias NovyData.Accounts.AuthProvider

  describe "auth providers" do
    @valid_auth_provider_attrs %{
      label: "PROVIDER",
      method: "METHOD",
      active: true,
      client_id: "CLIENT ID",
      client_secret: "CLIENT SECRET",
      authorize_url: "AUTHORIZE URL",
      token_url: "TOKEN URL",
      user_url: "USER URL",
      scope: "SCOPE",
      response_type: "RESPONSE TYPE",
      user_path: "USER PATH",
      user_id_path: "USER ID PATH",
      user_pseudo_path: "USER PSEUDO PATH",
      user_img_url: "USER IMG URL",
      user_img_path: "USER IMG PATH"
    }

    test "list_auth_providers/0 returns all auth providers" do
      %AuthProvider{id: auth_provider_id1} = auth_provider_fixture()
      assert [%AuthProvider{id: ^auth_provider_id1}] = AuthProvider.list_auth_providers()
      %AuthProvider{id: auth_provider_id2} = auth_provider_fixture()

      assert [%AuthProvider{id: ^auth_provider_id1}, %AuthProvider{id: ^auth_provider_id2}] =
               AuthProvider.list_auth_providers()
    end

    test "get_auth_provider!/1 returns the auth providers with given id" do
      %AuthProvider{id: id} = auth_provider_fixture()
      assert %AuthProvider{id: ^id} = AuthProvider.get_auth_provider!(id)
    end

    test "get_auth_provider/1 returns the auth providers with given id" do
      %AuthProvider{id: id} = auth_provider_fixture()
      assert %AuthProvider{id: ^id} = AuthProvider.get_auth_provider(id)
    end

    test "create_auth_provider/1 with valid data creates a auth provider" do
      assert {:ok, %AuthProvider{} = auth_provider} =
               AuthProvider.create_auth_provider(@valid_auth_provider_attrs)

      assert auth_provider.label == "PROVIDER"
      assert auth_provider.method == "METHOD"
      assert auth_provider.active == true
      assert auth_provider.client_id == "CLIENT ID"
      assert auth_provider.client_secret == "CLIENT SECRET"
      assert auth_provider.authorize_url == "AUTHORIZE URL"
      assert auth_provider.token_url == "TOKEN URL"
      assert auth_provider.user_url == "USER URL"
      assert auth_provider.scope == "SCOPE"
      assert auth_provider.response_type == "RESPONSE TYPE"
      assert auth_provider.user_path == "USER PATH"
      assert auth_provider.user_id_path == "USER ID PATH"
      assert auth_provider.user_pseudo_path == "USER PSEUDO PATH"
      assert auth_provider.user_img_url == "USER IMG URL"
      assert auth_provider.user_img_path == "USER IMG PATH"
    end

    test "update_auth_provider/2 with valid data updates the auth provider" do
      auth_provider = auth_provider_fixture()

      assert {:ok, auth_provider} =
               AuthProvider.update_auth_provider(auth_provider, %{label: "UPDATED LABEL"})

      assert %AuthProvider{} = auth_provider
      assert auth_provider.label == "UPDATED LABEL"
    end

    test "delete_auth_provider/1 delete the auth provider" do
      auth_provider = auth_provider_fixture()

      assert {:ok, %AuthProvider{}} = AuthProvider.delete_auth_provider(auth_provider)
      assert AuthProvider.list_auth_providers() == []
    end

    test "change_auth_provider/1 returns a auth provider changeset" do
      auth_provider = auth_provider_fixture()

      assert %Ecto.Changeset{} = AuthProvider.change_auth_provider(auth_provider)
    end
  end
end
