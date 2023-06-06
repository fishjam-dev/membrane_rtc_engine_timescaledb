defmodule Membrane.RTC.Engine.TimescaleDB.Migration do
  @moduledoc false

  @callback up() :: :ok
  @callback down() :: :ok
end

defmodule Membrane.RTC.Engine.TimescaleDB.Migrations do
  @latest_migration 2

  @moduledoc """
  Migrations creating DB tables required by this library to function.
  To execute migrations, run `#{__MODULE__}.up(versions: 1..2)` or `#{__MODULE__}.up(version: 2)`.
  To undo them, run `#{__MODULE__}.down(versions: 1..2)` or `#{__MODULE__}.down(version: 2)` accordingly.
  Currently, the latest migrations version is `#{@latest_migration}`
  Suggested way of using functions from this module, is to create a migration module in your own
  project and call them there. Remember, that versions passed to `down` should match ones passed to
  `up`. Here's an example:

  ```elixir
  defmodule MyApp.CreateRtcEngineTimescaledbTables do
    use Ecto.Migration

    @spec up() :: :ok
    def up() do
      :ok = #{__MODULE__}.up(versions: 1..2)
    end

    @spec down() :: :ok
    def down() do
      :ok = #{__MODULE__}.down(versions: 1..2)
    end
  end
  ```

  When updating, create a new migration applying newer `TimescaleDB` migrations, e.g. assuming you
  already have migrations to version 1, you should write:
  ```elixir
  defmodule MyApp.UpdateRtcEngineTimescaledbTablestoV2 do
    use Ecto.Migration

    @spec up() :: :ok
    def up() do
      :ok = #{__MODULE__}.up(version: 2)
    end

    @spec down() :: :ok
    def down() do
      :ok = #{__MODULE__}.down(version: 2)
    end
  end
  ```
  """

  @type version_spec() :: [version: pos_integer()] | [versions: Range.t()]

  @deprecated "Use up/1 with explicit version(s)"
  @spec up() :: :ok
  def up(), do: up(version: 1)

  @spec up(version_spec()) :: :ok
  def up(version: version)
      when is_integer(version) and version >= 1 and version <= @latest_migration do
    change(version..version, :up)
  end

  def up(versions: _from.._to//1 = versions) do
    change(versions, :up)
  end

  @deprecated "Use down/1 with explicit version(s)"
  @spec down() :: :ok
  def down(), do: down(version: 1)

  @spec down(version_spec()) :: :ok
  def down(version: version)
      when is_integer(version) and version >= 1 and version <= @latest_migration do
    change(version..version, :down)
  end

  def down(versions: from..to//1) do
    change(to..from//-1, :down)
  end

  defp change(versions_range, direction) do
    for version <- versions_range do
      version_string = String.pad_leading(to_string(version), 2, "0")

      [__MODULE__, "V#{version_string}"]
      |> Module.concat()
      |> apply(direction, [])
    end

    :ok
  end
end
