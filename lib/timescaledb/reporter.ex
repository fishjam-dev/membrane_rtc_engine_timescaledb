defmodule Membrane.RTC.Engine.TimescaleDB.Reporter do
  @moduledoc """
  Worker responsible for inserting data to database and deleting data from it
  """

  use GenServer

  alias Membrane.RTC.Engine.TimescaleDB.Model

  @type reporter :: pid() | atom()

  @spec start(module(), GenServer.options()) :: GenServer.on_start()
  def start(repo, options \\ []) do
    do_start(:start, repo, options)
  end

  @spec start_link(module(), GenServer.options()) :: GenServer.on_start()
  def start_link(repo, options \\ []) do
    do_start(:start_link, repo, options)
  end

  defp do_start(function, repo, options) do
    apply(GenServer, function, [__MODULE__, repo, options])
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
  def child_spec(opts) do
    {repo, process_opts} = Keyword.pop(opts, :repo, nil)

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [repo, process_opts]}
    }
  end

  @impl true
  def init(repo) do
    {:ok, %{repo: repo}}
  end

  @impl true
  def handle_cast({:store_report, report}, state) do
    Model.insert_report(state.repo, report)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:cleanup, count, interval}, state) do
    Model.remove_outdated_records(state.repo, count, interval)
    {:noreply, state}
  end
end
