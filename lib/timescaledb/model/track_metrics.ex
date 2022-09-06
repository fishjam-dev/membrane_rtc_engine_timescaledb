defmodule Membrane.RTC.Engine.TimescaleDB.Model.TrackMetrics do
  @moduledoc """
  Model representing set of track metrics from `Membrane.RTC.Engine` metrics report.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Membrane.RTC.Engine.TimescaleDB.Model.PeerMetrics

  @type t :: %__MODULE__{
          id: integer(),
          track_id: String.t(),
          "inbound-rtp.encoding": non_neg_integer() | nil,
          "inbound-rtp.ssrc": non_neg_integer() | nil,
          "inbound-rtp.bytes_received": non_neg_integer() | nil,
          "inbound-rtp.keyframe_request_sent": non_neg_integer() | nil,
          "inbound-rtp.packets": non_neg_integer() | nil,
          "inbound-rtp.frames": non_neg_integer() | nil,
          "inbound-rtp.keyframes": non_neg_integer() | nil,
          peer_metrics_id: :id,
          peer_metrics: PeerMetrics,
          inserted_at: DateTime.t()
        }

  @primary_key {:id, :id, autogenerate: true}
  schema "tracks_metrics" do
    field(:track_id, :string)
    field(:peer_id, :string)
    field(:"inbound-rtp.encoding", :string)
    field(:"inbound-rtp.ssrc", :string)
    field(:"inbound-rtp.bytes_received", :integer)
    field(:"inbound-rtp.keyframe_request_sent", :integer)
    field(:"inbound-rtp.packets", :integer)
    field(:"inbound-rtp.frames", :integer)
    field(:"inbound-rtp.keyframes", :integer)

    timestamps(type: :utc_datetime_usec, updated_at: false)

    belongs_to(:peer_metrics, PeerMetrics)
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
          :"inbound-rtp.keyframes"
        ]

    schema
    |> cast(params, casted_fields)
    |> validate_required(required_fields)
  end
end
