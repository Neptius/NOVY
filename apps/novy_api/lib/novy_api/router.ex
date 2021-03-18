defmodule NovyApi.Router do
  use NovyApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NovyApi do
    pipe_through :api

    get "/", DefaultController, :index
  end

  scope "/api", NovyApi do
    pipe_through :api
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: NovyApi.Telemetry
    end
  end
end
