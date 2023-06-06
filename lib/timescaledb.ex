defmodule Membrane.RTC.Engine.TimescaleDB do
  @moduledoc """
  Allows to store `Membrane.RTC.Engine` metrics reports in a database.
  """

  @type report() :: %{
          optional({:room_id, binary()}) => %{
            optional({:peer_id, binary()}) => %{
              {:track_id, binary()} => %{
                :"inbound-rtp.encoding" => atom(),
                :"inbound-rtp.ssrc" => integer(),
                :"inbound-rtp.bytes_received" => integer(),
                :"inbound-rtp.keyframe_request_sent" => integer(),
                :"inbound-rtp.packets" => integer(),
                :"inbound-rtp.frames" => integer(),
                :"inbound-rtp.keyframes" => integer()
              },
              :"ice.binding_requests_received" => integer(),
              :"ice.binding_responses_sent" => integer(),
              :"ice.bytes_received" => integer(),
              :"ice.bytes_sent" => integer(),
              :"ice.packets_received" => integer(),
              :"ice.packets_sent" => integer()
            }
          }
        }

  @doc """
  Stores `Membrane.RTC.Engine` metrics report in the database using `:repo` module passed in Application environment.
  """
  @spec store_report(report()) :: :ok
  defdelegate store_report(report), to: __MODULE__.Reporter
end
