defmodule NovySite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NovySite.Telemetry,
      # Start a worker by calling: NovySite.Worker.start_link(arg)
      # {NovySite.Worker, arg}
      {Phoenix.PubSub, name: NovySite.PubSub},
      NovySite.Presence,

      # Start the Endpoint (http/https)
      NovySite.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NovySite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NovySite.Endpoint.config_change(changed, removed)
    :ok
  end
end
