import Config

config :phoenix, :json_library, Jason
config :logger, :level, :warning

config :ckeditor5, Playground.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  secret_key_base: "xK4YhC5V4rUFGa5biXASSgET/yIL4lAuvwrSqZgFP1vJx2kmv1Pb2/4ihxjcT3mE",
  live_view: [signing_salt: "hMegieSe"],
  debug_errors: true,
  check_origin: false,
  code_reloader: false,
  render_errors: [view: Playground.View, accepts: ~w(html)],
  server: false,
  pubsub_server: Playground.PubSub
