import Config

# those config values are loaded just for tests
# once the package is included in other project the config
# gets ignored, see: https://hexdocs.pm/elixir/library-guidelines.html#avoid-application-configuration

config :membrane_rtc_engine_timescaledb, ecto_repos: [Membrane.RTC.Engine.TimescaleDB.Test.Repo]

config :membrane_rtc_engine_timescaledb, Membrane.RTC.Engine.TimescaleDB.Test.Repo,
  database: "membrane_rtc_engine_timescaledb_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/support/"

config :membrane_rtc_engine_timescaledb, repo: Membrane.RTC.Engine.TimescaleDB.Test.Repo
