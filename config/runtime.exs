import Config

# In this file, we load production configuration and secrets

# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.

if config_env() == :prod do
  config :novy_data,
    aws_access_key_id: System.get_env("AWS_ACCESS_KEY_ID") || "",
    aws_secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY") || "",
    aws_s3_bucket: System.get_env("AWS_S3_BUCKET") || ""

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :novy_data, NovyData.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :novy_admin, NovyAdmin.Endpoint,
    http: [
      port: 10002,
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: "admin.novy.dev", port: 80],
    cache_static_manifest: "priv/static/cache_manifest.json",
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
    http: [
      port: 10001,
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: "novy.dev", port: 80],
    cache_static_manifest: "priv/static/cache_manifest.json",
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
    http: [
      port: 10000,
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: "api.novy.dev", port: 80],
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
end
