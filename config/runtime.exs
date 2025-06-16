import Config

case config_env() do
  :test ->
    config :logger, level: :warning, default_handler: false
  :dev ->
    config :logger, level: :debug, default_handler: :console
  _ ->
    config :logger, level: :info, default_handler: :console
end
