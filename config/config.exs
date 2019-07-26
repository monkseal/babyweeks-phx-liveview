# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :babyweeks,
  ecto_repos: [Babyweeks.Repo]

# Configures the endpoint
config :babyweeks, BabyweeksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5zzbts6+pHkSlUuMh8I+j7Q5t+UBNSW5LIA3wvFmvyVl5coLo+aPWRjHLs7yCPlw",
  render_errors: [view: BabyweeksWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Babyweeks.PubSub, adapter: Phoenix.PubSub.PG2]

config :babyweeks, BabyweeksWeb.Endpoint,
   live_view: [
     signing_salt: "hYqv6RCofyCo1oZveZPl0GsUq9n94J81"
   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
