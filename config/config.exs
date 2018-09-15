# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hub,
  ecto_repos: [Hub.Repo]

# Configures the endpoint
config :hub, HubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ECY8Cv2Gs9j1W8S1SKMSkk7wTDf/V/P/3xq+XayBMdpAB8YWNp45dY8J4Gh7tKCL",
  render_errors: [view: HubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hub.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
