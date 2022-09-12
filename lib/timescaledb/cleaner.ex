defmodule Membrane.RTC.Engine.TimescaleDB.Cleaner do
  @moduledoc """
  Worker responsible for deleting obsolete records from the database.
  By default started under the application's supervision tree with params passed in the application config.
  `start/1` and `start_link/1` functions expect a keyword list as an argument, with the following keys:
    * `:repo` (required) is a module, that uses `Ecto.Repo`
    * `:cleanup_interval` (default: 1 hour) is the number of seconds between database cleanups
    * `:metrics_lifetime` (default: 24 hours) is the number of seconds that must pass from creation before each metric can be deleted during cleanup
  The keyword may also include `GenServer` options, see `t:GenServer.option/0` for reference.
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
    unless Keyword.has_key?(options, :repo) do
      raise ":repo key is required in keyword list passed to #{__MODULE__}.#{function}/1 function, got #{inspect(options)}"
    end

    {reporter_options, gen_server_options} =
      Keyword.split(options, [:repo, :cleanup_interval, :metrics_lifetime])

    apply(GenServer, function, [__MODULE__, reporter_options, gen_server_options])
  end

  @impl true
  def init(opts) do
    cleanup_interval_ms =
      Keyword.get(opts, :cleanup_interval, 60 * 60)
      |> Membrane.Time.seconds()
      |> Membrane.Time.as_milliseconds()

    metrics_lifetime_s = Keyword.get(opts, :metrics_lifetime, 60 * 60 * 24)

    state = %{
      repo: opts[:repo],
      cleanup_interval_ms: cleanup_interval_ms,
      metrics_lifetime_s: metrics_lifetime_s
    }

    Process.send_after(self(), :cleanup, cleanup_interval_ms)

    {:ok, state}
  end

  @impl true
  def handle_info(:cleanup, state) do
    Model.remove_outdated_records(state.repo, state.metrics_lifetime_s, "second")
    Process.send_after(self(), :cleanup, state.cleanup_interval_ms)
    {:noreply, state}
  end
end
