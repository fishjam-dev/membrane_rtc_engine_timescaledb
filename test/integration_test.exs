defmodule Membrane.RTC.Engine.TimescaleDB.IntegrationTest do
  use ExUnit.Case, async: true

  alias Membrane.RTC.Engine.TimescaleDB.{Cleaner, Model}
  alias Membrane.RTC.Engine.TimescaleDB.Test.Repo

  alias Model.{
    PeerMetrics,
    TrackMetrics
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "Reporter stores" do
    test "report in the db" do
      Model.insert_report(Repo, rtc_engine_report_1())

      assert Repo.all(PeerMetrics) |> length() == 2
      assert Repo.all(TrackMetrics) |> length() == 3
    end

    test "multiple reports in the db" do
      Model.insert_report(Repo, rtc_engine_report_1())
      Model.insert_report(Repo, rtc_engine_report_2())

      assert Repo.all(PeerMetrics) |> length() == 3
      assert Repo.all(TrackMetrics) |> length() == 4
    end
  end

  describe "Cleaner removes" do
    @tag :long_running
    test "old vales from the db" do
      {:ok, cleaner} =
        Cleaner.start_link(cleanup_interval: 1, metrics_lifetime: 4, repo: Repo, name: Cleaner)

      Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), cleaner)

      Model.insert_report(Repo, rtc_engine_report_1())

      Process.sleep(3000)

      Model.insert_report(Repo, rtc_engine_report_2())

      assert Repo.all(PeerMetrics) |> length() == 3
      assert Repo.all(TrackMetrics) |> length() == 4

      Process.sleep(3000)

      assert Repo.all(PeerMetrics) |> length() == 1
      assert Repo.all(TrackMetrics) |> length() == 1
    end
  end

  defp rtc_engine_report_1() do
    %{
      {:room_id, "Daily"} => %{
        {:peer_id, "Adam"} => %{
          {:track_id, "AdamAudioTrack"} => %{
            :"inbound-rtp.encoding" => :OPUS,
            :"inbound-rtp.ssrc" => 1,
            :"inbound-rtp.bytes_received" => 1,
            :"inbound-rtp.packets" => 1,
            :"track.metadata" => nil
          },
          {:track_id, "AdamVideoTrack"} => %{
            :"inbound-rtp.encoding" => :VP8,
            :"inbound-rtp.ssrc" => 2,
            :"inbound-rtp.bytes_received" => 1,
            :"inbound-rtp.keyframe_request_sent" => 1,
            :"inbound-rtp.packets" => 1,
            :"inbound-rtp.frames" => 1,
            :"inbound-rtp.keyframes" => 1,
            :"track.metadata" => nil
          },
          :"ice.binding_requests_received" => 1,
          :"ice.binding_responses_sent" => 1,
          :"ice.bytes_received" => 1,
          :"ice.bytes_sent" => 1,
          :"ice.packets_received" => 1,
          :"ice.packets_sent" => 1,
          :"peer.metadata" => nil
        },
        {:peer_id, "John"} => %{
          {:track_id, "JohnAudioTrack"} => %{
            :"inbound-rtp.encoding" => :OPUS,
            :"inbound-rtp.ssrc" => 3,
            :"inbound-rtp.bytes_received" => 1,
            :"inbound-rtp.packets" => 1,
            :"track.metadata" => nil
          },
          :"ice.binding_requests_received" => 1,
          :"ice.binding_responses_sent" => 1,
          :"ice.bytes_received" => 1,
          :"ice.bytes_sent" => 1,
          :"ice.packets_received" => 1,
          :"ice.packets_sent" => 1,
          :"peer.metadata" => nil
        }
      }
    }
  end

  defp rtc_engine_report_2() do
    %{
      {:room_id, "Planning"} => %{
        {:peer_id, "Caroline"} => %{
          {:track_id, "CarolineAudioTrack"} => %{
            :"inbound-rtp.encoding" => :OPUS,
            :"inbound-rtp.ssrc" => 10,
            :"inbound-rtp.bytes_received" => 1,
            :"inbound-rtp.packets" => 1,
            :"track.metadata" => nil
          },
          :"ice.binding_requests_received" => 1,
          :"ice.binding_responses_sent" => 1,
          :"ice.bytes_received" => 1,
          :"ice.bytes_sent" => 1,
          :"ice.packets_received" => 1,
          :"ice.packets_sent" => 1,
          :"peer.metadata" => nil
        }
      }
    }
  end
end
