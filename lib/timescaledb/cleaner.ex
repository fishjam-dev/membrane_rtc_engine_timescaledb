defmodule Membrane.RTC.Engine.TimescaleDB.Cleaner do
  @moduledoc """
  Worker responsible for inserting data to database and deleting data from it.
  By default started in project application module in supervison tree with params passed in application config.
  """

  use GenServer

  alias Membrane.RTC.Engine.TimescaleDB.Model

  @type cleaner() :: pid() | atom()
  @type option() ::
          GenServer.option()
          | {:cleanup_interval, pos_integer()}
          | {:metrics_lifetime, pos_integer()}
          | {:repo, module()}
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

  @spec stop(cleaner()) :: :ok
  def stop(cleaner) do
    GenServer.cast(cleaner, :stop)
  end

  @impl true
  def init(opts) do
    state = %{
      repo: opts[:repo],
      cleanup_interval_ms:
        opts[:cleanup_interval] |> Membrane.Time.seconds() |> Membrane.Time.as_milliseconds(),
      metrics_lifetime: opts[:metrics_lifetime]
    }

    Process.send_after(self(), :cleanup, state.cleanup_interval_ms)

    {:ok, state}
  end

  @impl true
  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:cleanup, state) do
    Model.remove_outdated_records(state.repo, state.metrics_lifetime, "second")
    Process.send_after(self(), :cleanup, state.cleanup_interval_ms)
    {:noreply, state}
  end
end
