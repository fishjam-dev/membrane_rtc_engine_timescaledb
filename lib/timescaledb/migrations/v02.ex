defmodule Membrane.RTC.Engine.TimescaleDB.Migrations.V02 do
  @moduledoc false

  @behaviour Membrane.RTC.Engine.TimescaleDB.Migration

  use Ecto.Migration

  @impl true
  def up() do
    create index(:tracks_metrics, [:peer_metrics_id])

    :ok
  end

  @impl true
  def down() do
    drop index(:tracks_metrics, [:peer_metrics_id])

    :ok
  end
end
