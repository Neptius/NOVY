defmodule NovyData.TestHelpers do
  alias NovyData.Accounts.AuthProvider

  def auth_provider_fixture(attrs \\ %{}) do
    raw_auth_provider = %{
      label: "provider-#{System.unique_integer([:positive])}",
      method: attrs[:method] || "oauth2",
      active: true,
      client_id: "CLIENT ID",
      client_secret: "CLIENT SECRET",
      authorize_url: "AUTHORIZE URL",
      redirect_url: "REDIRECT URL",
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

    {:ok, auth_provider} =
      attrs
      |> Enum.into(raw_auth_provider)
      |> AuthProvider.create_auth_provider()

    auth_provider
  end
end
