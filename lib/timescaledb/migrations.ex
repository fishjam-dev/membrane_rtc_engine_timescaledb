defmodule Membrane.RTC.Engine.TimescaleDB.Migrations do
  @moduledoc """
  Module providing functionality of creating and deleting DB tables, expected by this library to function.
  """

  alias Membrane.RTC.Engine.TimescaleDB.Migrations

  @spec up() :: :ok
  def up() do
    Migrations.V01.up()
  end

  @spec down() :: :ok
  def down() do
    Migrations.V01.down()
  end
end
