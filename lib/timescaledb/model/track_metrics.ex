defmodule Membrane.RTC.Engine.TimescaleDB.Model.TrackMetrics do
  @moduledoc """
  Model representing a set of track metrics from `Membrane.RTC.Engine` metrics report.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Membrane.RTC.Engine.TimescaleDB.Model.PeerMetrics

  @type t :: %__MODULE__{
          id: integer() | nil,
          track_id: String.t() | nil,
          "inbound-rtp.encoding": non_neg_integer() | nil,
          "inbound-rtp.ssrc": non_neg_integer() | nil,
          "inbound-rtp.bytes_received": non_neg_integer() | nil,
          "inbound-rtp.keyframe_request_sent": non_neg_integer() | nil,
          "inbound-rtp.packets": non_neg_integer() | nil,
          "inbound-rtp.frames": non_neg_integer() | nil,
          "inbound-rtp.keyframes": non_neg_integer() | nil,
          "rtcp.sender_reports_received": non_neg_integer() | nil,
          "rtcp.total_packets_received": non_neg_integer() | nil,
          "inbound-rtp.markers_received": non_neg_integer() | nil,
          "outbound-rtp.markers_sent": non_neg_integer() | nil,
          "rtcp.total_packets_sent": non_neg_integer() | nil,
          "rtcp.nack_sent": non_neg_integer() | nil,
          "rtcp.fir_sent": non_neg_integer() | nil,
          "rtcp.sender_reports_sent": non_neg_integer() | nil,
          "rtcp.recevier_reports_sent": non_neg_integer() | nil,
          "rtcp.nack_received": non_neg_integer() | nil,
          "rtcp.fir_received": non_neg_integer() | nil,
          "rtcp.pli_received": non_neg_integer() | nil,
          "rtcp.sender_reports_received": non_neg_integer() | nil,
          "rtcp.recevier_reports_received": non_neg_integer() | nil,
          "outbound-rtp.rtx_sent": non_neg_integer() | nil,
          "outbound-rtp.packets": non_neg_integer() | nil,
          "outbound-rtp.bytes": non_neg_integer() | nil,
          peer_id: String.t() | nil,
          peer_metrics_id: integer() | nil,
          peer_metrics: PeerMetrics.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: DateTime.t() | nil
        }

  schema "tracks_metrics" do
    field :track_id, :string
    field :peer_id, :string
    field :"inbound-rtp.encoding", :string
    field :"inbound-rtp.ssrc", :string
    field :"inbound-rtp.bytes_received", :integer
    field :"inbound-rtp.keyframe_request_sent", :integer
    field :"inbound-rtp.packets", :integer
    field :"inbound-rtp.frames", :integer
    field :"inbound-rtp.keyframes", :integer
    field :"rtcp.sender_reports_received", :integer
    field :"rtcp.total_packets_received", :integer
    field :"inbound-rtp.markers_received", :integer
    field :"outbound-rtp.markers_sent", :integer
    field :"rtcp.total_packets_sent", :integer
    field :"rtcp.nack_sent", :integer
    field :"rtcp.fir_sent", :integer
    field :"rtcp.sender_reports_sent", :integer
    field :"rtcp.recevier_reports_sent", :integer
    field :"rtcp.nack_received", :integer
    field :"rtcp.fir_received", :integer
    field :"rtcp.pli_received", :integer
    field :"rtcp.sender_reports_received", :integer
    field :"rtcp.recevier_reports_received", :integer
    field :"outbound-rtp.rtx_sent", :integer
    field :"outbound-rtp.packets", :integer
    field :"outbound-rtp.bytes", :integer

    timestamps type: :utc_datetime_usec, updated_at: false

    belongs_to :peer_metrics, PeerMetrics
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(schema, params) do
    required_fields = [:track_id]

    casted_fields =
      required_fields ++
        [
          :peer_id,
          :peer_metrics_id,
          :"inbound-rtp.encoding",
          :"inbound-rtp.ssrc",
          :"inbound-rtp.bytes_received",
          :"inbound-rtp.keyframe_request_sent",
          :"inbound-rtp.packets",
          :"inbound-rtp.frames",
          :"inbound-rtp.keyframes",
          :"rtcp.sender_reports_received",
          :"rtcp.total_packets_received",
          :"inbound-rtp.markers_received",
          :"outbound-rtp.markers_sent",
          :"rtcp.total_packets_sent",
          :"rtcp.nack_sent",
          :"rtcp.fir_sent",
          :"rtcp.sender_reports_sent",
          :"rtcp.recevier_reports_sent",
          :"rtcp.nack_received",
          :"rtcp.fir_received",
          :"rtcp.pli_received",
          :"rtcp.sender_reports_received",
          :"rtcp.recevier_reports_received",
          :"outbound-rtp.rtx_sent",
          :"outbound-rtp.packets",
          :"outbound-rtp.bytes"
        ]

    schema
    |> cast(params, casted_fields)
    |> validate_required(required_fields)
  end
end
