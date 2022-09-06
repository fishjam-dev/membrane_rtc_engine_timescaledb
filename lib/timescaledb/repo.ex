defmodule Membrane.RTC.Engine.TimescaleDB.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :membrane_rtc_engine_timescaledb,
    adapter: Ecto.Adapters.Postgres
end
