defmodule Membrane.RTC.Engine.TimescaleDB.Model.TrackToPeer do
  @moduledoc """
  Model representing relation between peer and its tracks in `Membrane.RTC.Engine`.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          time: NaiveDateTime.t() | nil,
          track_id: String.t() | nil,
          peer_id: String.t() | nil
        }

  @unique_index_name :track_to_peer_track_id_peer_id_index

  @primary_key false
  schema "track_to_peer" do
    field(:time, :naive_datetime_usec)
    field(:track_id, :string)
    field(:peer_id, :string)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(schema, params) do
    fields = [:time, :track_id, :peer_id]

    schema
    |> cast(params, fields)
    |> validate_required(fields)
    |> unique_constraint([:track_id, :peer_id], name: @unique_index_name)
  end

  @spec get_unique_index_name() :: atom()
  def get_unique_index_name(), do: @unique_index_name
end
