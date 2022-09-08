defmodule Membrane.RTC.Engine.TimescaleDB.Test.Repo.Migrations.CreateTables do
  use Ecto.Migration

  alias Membrane.RTC.Engine.TimescaleDB.Migrations

  def up() do
    Migrations.up()
  end

  def down() do
    Migrations.down()
  end
end
