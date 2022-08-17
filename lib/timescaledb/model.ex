defmodule Membrane.RTC.Engine.TimescaleDB.Model do
  @moduledoc """
  Module responsible for putting data to TimescaleDB.
  """

  import Ecto.Query

  alias Membrane.RTC.Engine.TimescaleDB.Repo
  alias Membrane.RTC.Engine.TimescaleDB.Model.{PeerMetrics, TrackMetrics}

  @doc """
  Takes `Membrane.RTC.Engine.Metrics.rtc_engine_report()` and puts it to database.
  """
  @spec insert_report(Membrane.RTC.Engine.Metrics.rtc_engine_report()) :: :ok
  def insert_report(report) do
    for {{:room_id, room_id}, room_report} <- report do
      for {{:peer_id, peer_id}, peer_report} <- room_report do
        {peer_metrics, tracks_reports} =
          Enum.split_with(peer_report, fn {key, _value} -> is_atom(key) end)

        tracks_metrics =
          Enum.map(tracks_reports, fn {{:track_id, track_id}, report} ->
            Map.put(report, :track_id, track_id)
            |> update_if_exists(:"inbound-rtp.ssrc", &inspect/1)
            |> update_if_exists(:"inbound-rtp.encoding", &Atom.to_string/1)
          end)

        [
          peer_id: peer_id,
          room_id: room_id,
          tracks_metrics: tracks_metrics
        ]
        |> Enum.concat(peer_metrics)
        |> Map.new()
        |> insert_peer_metrics()
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
    for model <- [PeerMetrics, TrackMetrics] do
      from(p in model, where: p.inserted_at < ago(^count, ^interval))
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
end
