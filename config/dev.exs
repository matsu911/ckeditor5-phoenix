import Config

config :phoenix, :json_library, Jason
config :logger, :level, :debug

config :ckeditor, Playground.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  secret_key_base: "nU11FRRf5rf675y2C/A/w5MMnFFg1gVNiOw/PQ+c3G6HZhTa282rEF73U/CJqRRN",
  live_view: [signing_salt: "asdFj3kL"],
  debug_errors: true,
  check_origin: false,
  code_reloader: true,
  render_errors: [view: Playground.View, accepts: ~w(html)],
  server: true,
  pubsub_server: Playground.PubSub,
  watchers: [
    node: ["esbuild.js", "--watch"]
  ],
  live_reload: [
    patterns: [
      ~r"playground/.*(ex|eex|js|css)$",
      ~r"lib/.*(ex|eex|js|css)$"
    ]
  ]
