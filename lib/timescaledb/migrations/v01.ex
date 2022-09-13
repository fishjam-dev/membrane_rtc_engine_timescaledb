defmodule Membrane.RTC.Engine.TimescaleDB.Migrations.V01 do
  @moduledoc false

  use Ecto.Migration

  @spec up() :: :ok
  def up() do
    create table(:peers_metrics) do
      add :peer_id, :string, null: false
      add :room_id, :string, null: false
      add :"ice.binding_requests_received", :integer
      add :"ice.binding_responses_sent", :integer
      add :"ice.bytes_received", :integer
      add :"ice.bytes_sent", :integer
      add :"ice.packets_received", :integer
      add :"ice.packets_sent", :integer

      timestamps type: :utc_datetime_usec, updated_at: false
    end

    create index(:peers_metrics, [:inserted_at])
    create index(:peers_metrics, [:peer_id])
    create index(:peers_metrics, [:inserted_at, :peer_id])

    flush()

    create table(:tracks_metrics) do
      add :track_id, :string, null: false

      add :peer_metrics_id,
          references(:peers_metrics, on_delete: :delete_all, on_update: :update_all)

      add :"inbound-rtp.encoding", :string
      add :"inbound-rtp.ssrc", :string
      add :"inbound-rtp.bytes_received", :integer
      add :"inbound-rtp.keyframe_request_sent", :integer
      add :"inbound-rtp.packets", :integer
      add :"inbound-rtp.frames", :integer
      add :"inbound-rtp.keyframes", :integer

      timestamps type: :utc_datetime_usec, updated_at: false
    end

    create index(:tracks_metrics, [:inserted_at])
    create index(:tracks_metrics, [:track_id])
    create index(:tracks_metrics, [:inserted_at, :track_id])

    :ok
  end

  @spec down() :: :ok
  def down() do
    drop table(:peers_metrics)
    drop table(:tracks_metrics)

    :ok
  end
end
