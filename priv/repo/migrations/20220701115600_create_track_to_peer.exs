defmodule Membrane.RTC.Engine.TimescaleDB.Repo.Migrations.CreateTrackToPeer do
  use Ecto.Migration

  def change do
    create table(:track_to_peer, primary_key: false) do
      add(:time, :naive_datetime_usec, null: false)
      add(:track_id, :string, null: false)
      add(:peer_id, :string, null: false)
    end

    unique_index_name = Membrane.RTC.Engine.TimescaleDB.Model.TrackToPeer.get_unique_index_name()
    create unique_index(:track_to_peer, [:track_id, :peer_id], name: unique_index_name)
    create index(:track_to_peer, [:peer_id])
  end
end
