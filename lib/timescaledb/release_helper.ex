defmodule Membrane.RTC.Engine.TimescaleDB.ReleaseHelper do
  @moduledoc """
  Provides functions facilitating releasing a project, that has a dependency to this library
  """

  @app :membrane_rtc_engine_timescaledb

  @doc """
  Takes a path to the `priv` directory of this repo (eg. in source code or release) and the target path, where the content of `priv/grafana` subdirectory will be copied.
  """
  @spec cp_grafana_directory(String.t(), String.t()) :: :ok
  def cp_grafana_directory(priv_path, target_path) do
    target_path =
      if String.ends_with?(target_path, "/"),
        do: target_path <> "grafana",
        else: target_path <> "/grafana"

    grafana_path =
      if String.ends_with?(priv_path, "/"),
        do: priv_path <> "grafana",
        else: priv_path <> "/grafana"

    File.mkdir_p(target_path)
    File.cp_r!(grafana_path, target_path)

    :ok
  end

  @doc """
  Returns version of library. Helpful, when coping Grafana configs in release.
  """
  @spec project_version() :: String.t()
  def project_version() do
    Application.spec(@app)
    |> Keyword.fetch!(:vsn)
    |> to_string()
  end
end
