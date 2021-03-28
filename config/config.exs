# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :novy_data,
  ecto_repos: [NovyData.Repo]

config :novy_data, NovyData.Accounts.User,
  database: "novy_data_user",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :novy_admin,
  generators: [context_app: false]

# Configures the endpoint
config :novy_admin, NovyAdmin.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rOTXlBNifFDhABANlND+1GzvkU57Zz6aXYpx6x9tpE7c/Ykg5uhYjcx0Hhh9oukY",
  render_errors: [view: NovyAdmin.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NovyAdmin.PubSub,
  live_view: [signing_salt: "n20K8Zj7"]

config :novy_site,
  generators: [context_app: false]

# Configures the endpoint
config :novy_site, NovySite.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7nhztUdhNJh/Di8FQEjxEeSVLmuqZ0jjzseFR5xexzQ7alJaDmjOmTdnhYHnKS11",
  render_errors: [view: NovySite.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NovySite.PubSub,
  live_view: [signing_salt: "b2kJq5B3"]

config :novy_api,
  generators: [context_app: false]

# Configures the endpoint
config :novy_api, NovyApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S9sC615nAp9wPKsV4c0LmTTuUotSD6V+KpZX4MUnDoA8qeMNeMo0d6I3VZcASNcm",
  render_errors: [view: NovyApi.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: NovyApi.PubSub,
  live_view: [signing_salt: "FlA4bBB1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
