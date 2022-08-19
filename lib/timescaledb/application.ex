defmodule Membrane.RTC.Engine.TimescaleDB.Application do
  @moduledoc false
  use Application

  @app_name :membrane_rtc_engine_timescaledb
  # 1 hour
  @default_cleanup_interval 60 * 60
  @cleanup_interval Application.get_env(@app_name, :cleanup_interval, @default_cleanup_interval)
  # 24 hours
  @default_metrics_lifetime  60 * 60 * 24
  @metrics_lifetime Application.get_env(@app_name, :metrics_lifetime, @default_metrics_lifetime)
  @repo Application.get_env(@app_name, :repo)

  @impl true
  def start(_start_type, _start_args) do
    children = [
      {Membrane.RTC.Engine.TimescaleDB.Cleaner,
       repo: @repo, cleanup_interval: @cleanup_interval, metrics_lifetime: @metrics_lifetime},
      {Membrane.RTC.Engine.TimescaleDB.Reporter, repo: @repo, name: Membrane.RTC.Engine.TimescaleDB.Reporter}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
