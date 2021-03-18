defmodule NovyData.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NovyData.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NovyData.PubSub}
      # Start a worker by calling: NovyData.Worker.start_link(arg)
      # {NovyData.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: NovyData.Supervisor)
  end
end
