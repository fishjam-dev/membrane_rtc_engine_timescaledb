import Config

# those config values are loaded just for tests
# once the package is included in other project the config
# gets ignored, see: https://hexdocs.pm/elixir/library-guidelines.html#avoid-application-configuration

config :membrane_rtc_engine_timescaledb, ecto_repos: [Membrane.RTC.Engine.TimescaleDB.Repo]

config :membrane_rtc_engine_timescaledb, Membrane.RTC.Engine.TimescaleDB.Repo,
  database: "membrane",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  chunk_time_interval: "10 minutes",
  chunk_compress_policy_interval: "10 minutes"
