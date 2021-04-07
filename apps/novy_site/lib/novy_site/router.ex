defmodule NovySite.Router do
  use NovySite, :router

  import NovySite.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NovySite.LayoutView, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers,
         %{
           #  "content-security-policy" => "default-src *",
           # "referrer-policy" => "strict-origin-when-cross-origin",
           "strict-transport-security" => "max-age=31536000",
           "permissions-policy" => "fullscreen *"
         }

    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NovySite do
    pipe_through :browser

    # * AUTH
    live "/login", LoginLive.Index, :index
    get "/login_return", AuthController, :callback
  end

  scope "/", NovySite do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index
    delete "/logout", AuthController, :delete

    live "/upload", UploadLive.Index, :index

    live "/auth_providers", AuthProviderLive.Index, :index
    live "/auth_providers/new", AuthProviderLive.Index, :new
    live "/auth_providers/:id/edit", AuthProviderLive.Index, :edit
    live "/auth_providers/:id", AuthProviderLive.Show, :show
    live "/auth_providers/:id/show/edit", AuthProviderLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", NovySite do
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
      live_dashboard "/dashboard", metrics: NovySite.Telemetry
    end
  end
end
