defmodule Membrane.RTC.Engine.TimescaleDB.GrafanaHelper do
  @moduledoc """
  Provides functions facilitating releasing a project, that has a dependency to this library
  """

  @app :membrane_rtc_engine_timescaledb

  @doc """
  Takes the target path, where the content from `priv/grafana` will be copied.
  """
  @spec cp_grafana_directory(String.t()) :: :ok
  def cp_grafana_directory(target_path) do
    target_path = Path.join(target_path, "grafana")
    grafana_path = Application.app_dir(@app, ["priv", "grafana"])

    File.mkdir_p(target_path)
    File.cp_r!(grafana_path, target_path)

    :ok
  end
end
