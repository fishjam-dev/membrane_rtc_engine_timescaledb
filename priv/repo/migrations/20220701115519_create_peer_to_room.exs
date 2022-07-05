defmodule Membrane.RTC.Engine.TimescaleDB.Repo.Migrations.CreatePeerToRoom do
  use Ecto.Migration

  def change do
    create table(:peer_to_room, primary_key: false) do
      add(:time, :naive_datetime_usec, null: false)
      add(:peer_id, :string, null: false)
      add(:room_id, :string, null: false)
    end

    unique_index_name = Membrane.RTC.Engine.TimescaleDB.Model.PeerToRoom.get_unique_index_name()
    create unique_index(:peer_to_room, [:room_id, :peer_id], name: unique_index_name)
    create index(:peer_to_room, [:room_id])
  end
end
