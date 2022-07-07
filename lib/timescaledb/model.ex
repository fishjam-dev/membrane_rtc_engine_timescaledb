defmodule Membrane.RTC.Engine.TimescaleDB.Model do
  @moduledoc """
  Module responsible for putting data to TimescaleDB.
  """

  import Ecto.Query

  alias Membrane.RTC.Engine.TimescaleDB.Repo

  alias Membrane.RTC.Engine.TimescaleDB.Model.{
    PeerMetrics,
    PeerToRoom,
    TrackMetrics,
    TrackToPeer
  }

  @doc """
  Takes `Membrane.RTC.Engine.Metrics.rtc_engine_report()` and puts it to database.
  """
  @spec insert_report(Membrane.RTC.Engine.Metrics.rtc_engine_report()) :: :ok
  def insert_report(report) do
    for {{:room_id, room_id}, room_report} <- report do
      for {{:peer_id, peer_id}, peer_report} <- room_report do
        {peer_metrics, tracks_reports} =
          Enum.split_with(peer_report, fn {key, _value} -> is_atom(key) end)

        %{peer_id: peer_id, room_id: room_id, time: NaiveDateTime.utc_now()}
        |> upsert_peer_to_room()

        Map.new([peer_id: peer_id, time: NaiveDateTime.utc_now()] ++ peer_metrics)
        |> update_if_exists(:"peer.metadata", &inspect/1)
        |> insert_peer_metrics()

        for {{:track_id, track_id}, track_report} <- tracks_reports do
          %{track_id: track_id, peer_id: peer_id, time: NaiveDateTime.utc_now()}
          |> upsert_track_to_peer()

          Map.merge(track_report, %{track_id: track_id, time: NaiveDateTime.utc_now()})
          |> update_if_exists(:"track.metadata", &inspect/1)
          |> update_if_exists(:"inbound-rtp.ssrc", &inspect/1)
          |> update_if_exists(:"inbound-rtp.encoding", &Atom.to_string/1)
          |> insert_track_metrics()
        end
      end
    end

    :ok
  end

  @doc """
  Takes count and interval.
  Deletes records in database older thant `count` * `interval`.
  `interval` might be `"year"`, `"month"`, `"week"`, `"day"`, `"hour"`, `"minute"`, `"second"`, `"millisecond"` or `"microsecond"`.
  """
  @spec remove_outdated_records(non_neg_integer(), String.t()) :: :ok
  def remove_outdated_records(count, interval) do
    for model <- [PeerMetrics, TrackMetrics, PeerToRoom, TrackToPeer] do
      from(p in model, where: p.time < ago(^count, ^interval))
      |> Repo.delete_all()
    end
  end

  defp update_if_exists(map, key, fun) do
    case map do
      %{^key => value} -> Map.put(map, key, fun.(value))
      _else -> map
    end
  end

  defp insert_peer_metrics(peer_metrics) do
    %PeerMetrics{}
    |> PeerMetrics.changeset(peer_metrics)
    |> Repo.insert()
  end

  defp insert_track_metrics(track_metrics) do
    %TrackMetrics{}
    |> TrackMetrics.changeset(track_metrics)
    |> Repo.insert()
  end

  defp upsert_peer_to_room(peer_to_room) do
    insert_result =
      %PeerToRoom{}
      |> PeerToRoom.changeset(peer_to_room)
      |> Repo.insert()

    with {:error, changeset} <- insert_result,
         true <- contains_unique_contraint_error(changeset) do
      %{
        peer_id: peer_id,
        room_id: room_id,
        time: time
      } = peer_to_room

      where(PeerToRoom, peer_id: ^peer_id, room_id: ^room_id)
      |> Repo.update_all(set: [time: time])
    end
  end

  defp upsert_track_to_peer(track_to_peer) do
    insert_result =
      %TrackToPeer{}
      |> TrackToPeer.changeset(track_to_peer)
      |> Repo.insert()

    with {:error, changeset} <- insert_result,
         true <- contains_unique_contraint_error(changeset) do
      %{
        peer_id: peer_id,
        track_id: track_id,
        time: time
      } = track_to_peer

      where(TrackToPeer, peer_id: ^peer_id, track_id: ^track_id)
      |> Repo.update_all(set: [time: time])
    end
  end

  defp contains_unique_contraint_error(changeset) do
    Enum.any?(
      changeset.errors,
      &match?({_field, {_msg, [{:constraint, :unique} | _tail]}}, &1)
    )
  end
end
