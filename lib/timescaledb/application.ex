defmodule Membrane.RTC.Engine.TimescaleDB.Application do
  @moduledoc false
  use Application

  @app_name :membrane_rtc_engine_timescaledb
  # 1 hour
  @default_cleanup_interval 60 * 60
  # 24 hours
  @default_metrics_lifetime 60 * 60 * 24

  @impl true
  def start(_start_type, _start_args) do
    optional_children =
      if do_cleanups() do
        [
          {Membrane.RTC.Engine.TimescaleDB.Cleaner,
           repo: repo(),
           cleanup_interval: cleanup_interval(),
           metrics_lifetime: metrics_lifetime()}
        ]
      else
        []
      end

    children =
      [
        {Membrane.RTC.Engine.TimescaleDB.Reporter,
         repo: repo(), name: Membrane.RTC.Engine.TimescaleDB.Reporter}
      ] ++ optional_children

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp do_cleanups() do
    Application.get_env(@app_name, :do_cleanups, true)
  end

  defp repo() do
    Application.get_env(@app_name, :repo)
  end

  defp metrics_lifetime() do
    Application.get_env(@app_name, :metrics_lifetime, @default_metrics_lifetime)
  end

  defp cleanup_interval() do
    Application.get_env(@app_name, :cleanup_interval, @default_cleanup_interval)
  end
end
