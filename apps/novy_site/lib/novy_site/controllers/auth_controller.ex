defmodule NovySite.AuthController do
  use NovySite, :controller
  alias NovyData.AuthService
  alias NovySite.UserAuth

  def login_callback(conn, params) do
    case AuthService.start_auth(params, NovySite.Endpoint.url()) do
      {:ok, user_id} ->
        conn
        |> UserAuth.log_in_user(user_id)

      {:error, error} ->
        conn
        |> UserAuth.log_in_fail(error)
    end
  end

  def link_callback(conn, params) do
    current_user = conn.assigns[:current_user]
    case AuthService.start_link(params, NovySite.Endpoint.url(), current_user.id) do
      {:ok, user_id} ->
        conn
        |> UserAuth.log_in_user(user_id)

      {:error, error} ->
        conn
        |> UserAuth.log_in_fail(error)
    end
  end

  def delete(conn, _params) do
    IO.inspect("logout")
    conn
    |> UserAuth.log_out_user()
  end
end
