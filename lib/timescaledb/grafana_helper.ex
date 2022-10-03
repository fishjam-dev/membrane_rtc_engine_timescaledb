defmodule Membrane.RTC.Engine.TimescaleDB.GrafanaHelper do
  @moduledoc """
  Provides functions facilitating releasing a project, that has a dependency to this library
  """

  @app :membrane_rtc_engine_timescaledb

  @doc """
  Takes a path to the `priv` directory of this repo (eg. in source code or release) and the target path, where the content of `priv/grafana` subdirectory will be copied.
  """
  @spec cp_grafana_directory(String.t()) :: :ok
  def cp_grafana_directory(target_path) do
    target_path = Path.join(target_path, "grafana")
    grafana_path = Application.app_dir(@app) |> Path.join("priv/grafana")

    File.mkdir_p(target_path)
    File.cp_r!(grafana_path, target_path)

    :ok
  end
end
