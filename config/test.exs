import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :novy_admin, NovyAdmin.Endpoint,
  http: [port: 11002],
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :novy_site, NovySite.Endpoint,
  http: [port: 11001],
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :novy_api, NovyApi.Endpoint,
  http: [port: 11000],
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :novy_data, NovyData.Repo,
  username: "postgres",
  password: "pass",
  database: "novy_db_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
