defmodule Membrane.RTC.Engine.TimescaleDB.Model.PeerToRoom do
  @moduledoc """
  Model representing relation between room and its peers in `Membrane.RTC.Engine`.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          time: NaiveDateTime.t() | nil,
          peer_id: String.t() | nil,
          room_id: String.t() | nil
        }

  @unique_index_name :peer_to_room_room_id_peer_id_index

  @primary_key false
  schema "peer_to_room" do
    field(:time, :naive_datetime_usec)
    field(:peer_id, :string)
    field(:room_id, :string)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(schema, params) do
    fields = [:time, :peer_id, :room_id]

    schema
    |> cast(params, fields)
    |> validate_required(fields)
    |> unique_constraint([:room_id, :peer_id], name: @unique_index_name)
  end

  @spec get_unique_index_name() :: atom()
  def get_unique_index_name(), do: @unique_index_name
end
