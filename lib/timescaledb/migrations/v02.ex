defmodule Membrane.RTC.Engine.TimescaleDB.Migrations.V02 do
  @moduledoc false

  use Ecto.Migration

  @spec change() :: :ok
  def change() do
    create index(:tracks_metrics, [:peer_metrics_id])

    :ok
  end
end
