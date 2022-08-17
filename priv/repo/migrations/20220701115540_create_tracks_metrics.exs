defmodule Membrane.RTC.Engine.TimescaleDB.Repo.Migrations.CreateTracksMetrics do
  use Ecto.Migration

  @chunk_time_interval Application.get_env(:membrane_rtc_engine_timescaledb, Repo)[:chunk_time_interval] || "10 minutes"

  def change do
    create table(:tracks_metrics, primary_key: {:id, :id, autogenerate: true}) do
      add :track_id, :string, null: false

      add :peer_metrics_id, references(:peers_metrics)

      add :"inbound-rtp.encoding", :string
      add :"inbound-rtp.ssrc", :string
      add :"inbound-rtp.bytes_received", :integer
      add :"inbound-rtp.keyframe_request_sent", :integer
      add :"inbound-rtp.packets", :integer
      add :"inbound-rtp.frames", :integer
      add :"inbound-rtp.keyframes", :integer

      timestamps()
    end

    create index(:tracks_metrics, [:inserted_at])
    create index(:tracks_metrics, [:track_id])
    create index(:tracks_metrics, [:inserted_at, :track_id])
  end
end
