defmodule Membrane.RTC.Engine.TimescaleDB.Reporter do
  @moduledoc """
  Worker responsible for inserting data to database and deleting data from it
  """

  use GenServer

  alias Membrane.RTC.Engine.TimescaleDB.Model

  @type reporter() :: pid() | atom()
  @type option() :: GenServer.option() | {:repo, module()}
  @type options() :: [option()]

  @spec start(options()) :: GenServer.on_start()
  def start(options \\ []) do
    do_start(:start, options)
  end

  @spec start_link(options()) :: GenServer.on_start()
  def start_link(options \\ []) do
    do_start(:start_link, options)
  end

  defp do_start(function, options) do
    {repo, gen_server_options} = Keyword.pop(options, :repo)
    apply(GenServer, function, [__MODULE__, repo, gen_server_options])
  end

  @spec store_report(reporter(), Membrane.RTC.Engine.Metrics.rtc_engine_report()) :: :ok
  def store_report(reporter \\ __MODULE__, report) do
    GenServer.cast(reporter, {:store_report, report})
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
end
