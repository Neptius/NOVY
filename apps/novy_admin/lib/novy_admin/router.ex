defmodule NovyAdmin.Router do
  use NovyAdmin, :router

  import NovyAdmin.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NovyAdmin.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NovyAdmin do
    pipe_through [:browser]

    live "/login", LoginLive.Index, :index
    get "/login_return", AuthController, :callback
  end

  scope "/", NovyAdmin do
    # pipe_through [:browser]
    pipe_through [:browser, :require_authenticated_user]

    live "/", DashboardLive.Index, :index
    delete "/logout", AuthController, :delete

    live "/auth_providers", AuthProviderLive.Index, :index
    live "/auth_providers/new", AuthProviderLive.Index, :new
    live "/auth_providers/:id/edit", AuthProviderLive.Index, :edit
    live "/auth_providers/:id", AuthProviderLive.Show, :show
    live "/auth_providers/:id/show/edit", AuthProviderLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", NovyAdmin do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NovyAdmin.Telemetry
    end
  end
end
