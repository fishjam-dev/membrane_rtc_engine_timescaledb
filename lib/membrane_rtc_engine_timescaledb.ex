defmodule Membrane.RTC.Engine.TimescaleDB.App do
  @moduledoc false
  use Application

  @impl true
  def start(_start_type, _start_args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
