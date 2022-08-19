defmodule Membrane.RTC.Engine.TimescaleDB.Cleaner do
  @moduledoc """
  Worker responsible for inserting data to database and deleting data from it.
  By default started in `Membrane.RTC.Engine.TimescaleDB.Application` module in supervison tree with params passed in application config.
  """

  use GenServer

  alias Membrane.RTC.Engine.TimescaleDB.Model

  @type cleaner() :: pid() | atom()
  @type option() ::
          GenServer.option()
          | {:cleanup_interval, pos_integer()}
          | {:metrics_lifetime, pos_integer()}
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
    {reporter_options, gen_server_options} =
      Keyword.split(options, [:repo, :cleanup_interval, :metrics_lifetime])

    apply(GenServer, function, [__MODULE__, reporter_options, gen_server_options])
  end

  @impl true
  def init(args) do
    state = Map.new(args)

    %{cleanup_interval: cleanup_interval, metrics_lifetime: _metrics_lifetime, repo: _repo} =
      state

    send_after_cleanup_interval(cleanup_interval)

    {:ok, state}
  end

  @impl true
  def handle_cast(:cleanup, state) do
    Model.remove_outdated_records(state.repo, state.metrics_lifetime, "second")
    send_after_cleanup_interval(state.cleanup_interval)
    {:noreply, state}
  end

  defp send_after_cleanup_interval(cleanup_interval) do
    Process.send_after(self(), :cleanup, 10000 * cleanup_interval)
  end
end
