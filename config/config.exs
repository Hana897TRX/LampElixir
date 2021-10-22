# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :bulb, BulbWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5QfoVNwjUh6+1mC0lEymQmjXSuTF5qtnQfjtEUrbmCjzuoO/N9R1BVyeJo6YXHFf",
  render_errors: [view: BulbWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bulb.PubSub,
  live_view: [signing_salt: "E+2YPHtU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
