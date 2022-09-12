defmodule Membrane.RTC.Engine.TimescaleDB.Migrations do
  @moduledoc """
  Migrations creating DB tables required by this library to function.
  """

  alias Membrane.RTC.Engine.TimescaleDB.Migrations

  @spec up() :: :ok
  def up() do
    Migrations.V01.up()

    :ok
  end

  @spec down() :: :ok
  def down() do
    Migrations.V01.down()

    :ok
  end
end
