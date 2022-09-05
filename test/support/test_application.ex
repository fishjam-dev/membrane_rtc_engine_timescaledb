defmodule Membrane.RTC.Engine.TimescaleDB.TestApplication do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [Membrane.RTC.Engine.TimescaleDB.Repo]

    opts = [strategy: :one_for_one, name: :membrane_rtc_engine_timescaledb]
    Supervisor.start_link(children, opts)
  end
end
