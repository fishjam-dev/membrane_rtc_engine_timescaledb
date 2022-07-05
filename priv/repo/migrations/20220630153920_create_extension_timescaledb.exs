defmodule Membrane.RTC.Engine.TimescaleDB.Repo.Migrations.CreateExtensionTimescaledb do
  use Ecto.Migration

  alias Membrane.Telemetry.TimescaleDB.Repo

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE")
  end

  def down do
    execute("DROP EXTENSION IF EXISTS timescaledb CASCADE")
  end
end
