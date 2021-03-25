import Config

# In this file, we load production configuration and secrets

# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :gen_tcp_accept_and_close, port: 8080

  config :master_proxy,
    http: [port: 8080],
    backends: [
      %{
        host: ~r{^www\.novy\.dev$},
        phoenix_endpoint: NovySite.Endpoint
      },
      %{
        host: ~r{^novy\.dev$},
        phoenix_endpoint: NovySite.Endpoint
      },
      %{
        host: ~r{^admin\.novy\.dev$},
        phoenix_endpoint: NovyAdmin.Endpoint
      },
      %{
        host: ~r{^api\.novy\.dev$},
        phoenix_endpoint: NovyApi.Endpoint
      }
    ]

  config :novy_admin, NovyAdmin.Endpoint,
    # http: [
    #   port: 10002,
    #   transport_options: [socket_opts: [:inet6]]
    # ],
    secret_key_base: secret_key_base,
    server: true

  # ## Using releases (Elixir v1.9+)
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :novy_admin, NovyAdmin.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  config :novy_site, NovySite.Endpoint,
    # http: [
    #   port: 10001,
    #   transport_options: [socket_opts: [:inet6]]
    # ],
    secret_key_base: secret_key_base,
    server: true

  # ## Using releases (Elixir v1.9+)
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :novy_site, NovySite.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  config :novy_api, NovyApi.Endpoint,
    # http: [
    #   port: 4000,
    #   transport_options: [socket_opts: [:inet6]]
    # ],
    secret_key_base: secret_key_base,
    server: true

  # ## Using releases (Elixir v1.9+)
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :novy_api, NovyApi.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :novy_data, NovyData.Repo,
    ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
