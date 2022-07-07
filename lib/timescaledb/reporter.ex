defmodule Membrane.RTC.Engine.TimescaleDB.Reporter do
  @moduledoc """
  Worker responsible for inserting data to database and deleting data from it
  """

  use GenServer

  alias Membrane.RTC.Engine.TimescaleDB.Model

  @type reporter :: pid() | atom()

  @spec start(GenServer.options()) :: GenServer.on_start()
  def start(options \\ []) do
    do_start(:start, options)
  end

  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(options \\ []) do
    do_start(:start_link, options)
  end

  defp do_start(function, options) do
    apply(GenServer, function, [__MODULE__, [], options])
  end

  @spec store_report(reporter(), Membrane.RTC.Engine.Metrics.rtc_engine_report()) :: :ok
  def store_report(reporter, report) do
    GenServer.cast(reporter, {:store_report, report})
  end

  @spec cleanup(reporter(), non_neg_integer(), String.t()) :: :ok
  def cleanup(reporter, count, interval) do
    GenServer.cast(reporter, {:cleanup, count, interval})
  end

  @spec child_spec(Keyword.t()) :: Supervisor.child_spec()
  def child_spec(process_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [process_opts]}
    }
  end

  @impl true
  def init(_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:store_report, report}, state) do
    Model.insert_report(report)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:cleanup, count, interval}, state) do
    Model.remove_outdated_records(count, interval)
    {:noreply, state}
  end
end
