defmodule Membrane.RTC.Engine.TimescaleDB do
  @moduledoc """
  Allows to store `Membrane.RTC.Engine` metrics reports in a database.
  """

  @doc """
  Stores `Membrane.RTC.Engine` metrics report in the database using `:repo` module passed in Application environment.
  """
  @spec store_report(Membrane.RTC.Engine.Metrics.rtc_engine_report()) :: :ok
  defdelegate store_report(report), to: __MODULE__.Reporter
end
