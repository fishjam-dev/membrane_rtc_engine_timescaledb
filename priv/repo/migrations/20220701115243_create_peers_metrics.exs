defmodule Membrane.RTC.Engine.TimescaleDB.Repo.Migrations.CreatePeersMetrics do
  use Ecto.Migration

  alias Membrane.Telemetry.TimescaleDB.Repo

  @chunk_time_interval Application.get_env(:membrane_rtc_engine_timescaledb, Repo)[:chunk_time_interval] || "10 minutes"

  def change do
    create table(:peers_metrics, primary_key: {:id, :id, autogenerate: true}) do
      add :peer_id, :string, null: false
      add :room_id, :string, null: false
      add :"ice.binding_requests_received", :integer
      add :"ice.binding_responses_sent", :integer
      add :"ice.bytes_received", :integer
      add :"ice.bytes_sent", :integer
      add :"ice.packets_received", :integer
      add :"ice.packets_sent", :integer

      timestamps()
    end

    create index(:peers_metrics, [:inserted_at])
    create index(:peers_metrics, [:peer_id])
    create index(:peers_metrics, [:inserted_at, :peer_id])
  end
end
