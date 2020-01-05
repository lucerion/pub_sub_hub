import Config

config :hub,
  port: String.to_integer(System.get_env("HUB_PORT") || "3000")
