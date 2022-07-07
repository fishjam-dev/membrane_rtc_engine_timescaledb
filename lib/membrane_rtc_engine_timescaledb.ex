defmodule Membrane.RTC.Engine.TimescaleDB.App do
  @moduledoc false
  use Application

  @impl true
  def start(_start_type, _start_args) do
    Application.ensure_all_started(:postgrex)

    children = [
      {Membrane.RTC.Engine.TimescaleDB.Repo, [show_sensitive_data_on_connection_error: true]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
