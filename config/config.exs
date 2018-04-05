# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :streaming,
  ecto_repos: [Streaming.Repo]

# Configures the endpoint
config :streaming, Streaming.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OhlnDJiSA09yXl8zg87ck5QsCIvj7V2qSyrH8/asI4IJwWhRG45+RQfa0YV+MOKF",
  render_errors: [view: Streaming.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Streaming.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
config :streaming, Streaming.Auth.Guardian,
    issuer: "Streaming", # Name of your app/company/product
    secret_key: "Nt0qBi9ewsB/9Yf+OA9mI/YXn/vMyPot3+oSPA5ONhwBU6bPtACZB3H+W07E+6/y"
     # Replace this with the output of the mix command
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :streaming, Streaming.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "x.x.x"


  config :guardian, Guardian,
 allowed_algos: ["HS512"], # optional
 verify_module: Guardian.JWT,  # optional
 issuer: "Streaming",
 ttl: { 30, :days },
 allowed_drift: 2000,
 verify_issuer: true, # optional
 secret_key: System.get_env("GUARDIAN_SECRET") || "xx...xxxx",
 serializer: Streaming.Web.GuardianSerializer

import_config "#{Mix.env}.exs"
