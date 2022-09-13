alias Membrane.RTC.Engine.TimescaleDB.Test.Repo

Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
ExUnit.start(exclude: [long_running: true], capture_log: true)
