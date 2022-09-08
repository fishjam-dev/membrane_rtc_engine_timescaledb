defmodule Membrane.RTC.Engine.TimescaleDB.Test.Repo.Migrations.CreateTables do
  use Ecto.Migration

  alias Membrane.RTC.Engine.TimescaleDB.Migrations

  @spec up() :: :ok
  def up() do
    :ok = Migrations.up()
  end

  @spec down() :: :ok
  def down() do
    :ok = Migrations.down()
  end
end
