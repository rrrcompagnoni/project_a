# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :project_a,
  ecto_repos: [ProjectA.Repo]

# Configures the endpoint
config :project_a, ProjectAWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gkXpbzVY8AXazyFhK9HE9vu6YwYeKak4fBBByyPu0jbQMVPTNuP8iCwuFNHuSmme",
  render_errors: [view: ProjectAWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProjectA.PubSub,
  live_view: [signing_salt: "gVzVCo/K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
