defmodule NovyAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NovyAdmin.Telemetry,
      # Start the Endpoint (http/https)
      NovyAdmin.Endpoint,
      # Start a worker by calling: NovyAdmin.Worker.start_link(arg)
      # {NovyAdmin.Worker, arg}
      {Phoenix.PubSub, name: NovyAdmin.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NovyAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NovyAdmin.Endpoint.config_change(changed, removed)
    :ok
  end
end
