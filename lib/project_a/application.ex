defmodule ProjectA.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ProjectA.Repo,
      # Start the Telemetry supervisor
      ProjectAWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ProjectA.PubSub},
      # Start the Endpoint (http/https)
      ProjectAWeb.Endpoint,
      # Start a worker by calling: ProjectA.Worker.start_link(arg)
      {ProjectA.Machinery.UsersScore, ProjectA.generate_score()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProjectA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ProjectAWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
