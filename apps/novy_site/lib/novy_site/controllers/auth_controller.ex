defmodule NovySite.AuthController do
  use NovySite, :controller
  alias NovyData.AuthService
  alias NovySite.UserAuth

  def callback(conn, params) do
    case AuthService.start_auth(params) do
      {:ok, user_id} ->
        conn
        |> UserAuth.log_in_user(user_id)

      {:error, error} ->
        conn
        |> UserAuth.log_in_fail(error)
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
