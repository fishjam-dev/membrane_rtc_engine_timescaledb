defmodule Membrane.RTC.Engine.TimescaleDB.Migrations do
  @moduledoc """
  Migrations creating DB tables required by this library to function.
  To execute migrations, run `#{__MODULE__}.up()`. To undo them and drop tables, run `#{__MODULE__}.down()`.
  Suggested way of using functions from this module, is to create a migration module in your own project and call them there, eg.
  ```elixir
  defmodule MyApp.CreateRtcEngineTimescaledbTables do
    use Ecto.Migration

    @spec up() :: :ok
    def up() do
      :ok = #{__MODULE__}.up()
    end

    @spec down() :: :ok
    def down() do
      :ok = #{__MODULE__}.down()
    end
  end
  ```
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
