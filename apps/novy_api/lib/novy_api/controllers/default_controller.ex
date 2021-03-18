defmodule NovyApi.DefaultController do
  use NovyApi, :controller

  def index(conn, _params) do
    {:ok, vsn} = :application.get_key(:novy_api, :vsn)
    version = List.to_string(vsn)
    render(conn, "api-data.json", data: %{"message" => "Hi, Tenno!", "version" => version})
  end
end
