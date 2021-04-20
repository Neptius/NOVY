defmodule NovyAdmin.AuthController do
  use NovyAdmin, :controller
  alias NovyData.AuthService
  alias NovyAdmin.UserAuth

  def callback(conn, params) do
    IO.inspect(NovyAdmin.Endpoint.url)
    # case AuthService.start_auth(params) do
    #   {:ok, user_id} ->
    #     conn
    #     |> UserAuth.log_in_user(user_id)

    #   {:error, error} ->
    #     conn
    #     |> UserAuth.log_in_fail(error)
    # end
    conn
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
