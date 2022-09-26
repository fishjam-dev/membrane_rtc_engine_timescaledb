# 

[![Hex.pm](https://img.shields.io/hexpm/v/membrane_rtc_engine_timescaledb.svg)](https://hex.pm/packages/membrane_rtc_engine_timescaledb)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](https://hexdocs.pm/membrane_rtc_engine_timescaledb)
[![CircleCI](https://circleci.com/gh/membraneframework/membrane_rtc_engine_timescaledb.svg?style=svg)](https://circleci.com/gh/membraneframework/membrane_rtc_engine_timescaledb)

This repository contains functions, that allows storing `Membrane.RTC.Engine` metrics reports in a database.

It is part of [Membrane Multimedia Framework](https://membraneframework.org).

## Installation

The package can be installed by adding `membrane_rtc_engine_timescaledb` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:membrane_rtc_engine_timescaledb, "~> 0.1.0"}
  ]
end
```

## Usage

To use `membrane_rtc_engine_timescaledb`, you have to have: 
 * running PostgreSQL database with Timescale extension
 * config for `:membrane_rtc_engine_timescaledb`
 * configured `Ecto` repo in your project
 * `Ecto` migration calling `Membrane.RTC.Engine.TimescaleDB.Migrations.up()` 

To create such a migration, execute `$ mix ecto.gen.migration create_rtc_engine_timescaledb_tables`, what will create new migration module, and add there calls to `up/0` and `down/0` from `Membrane.RTC.Engine.TimescaleDB.Migrations`. Your new migration module should look like the example below
```elixir
defmodule MyApp.CreateRtcEngineTimescaledbTables do
  use Ecto.Migration

  alias Membrane.RTC.Engine.TimescaleDB.Migrations

  @spec up() :: :ok
  def up() do
    :ok = Migrations.up()
  end

  @spec down() :: :ok
  def down() do
    :ok = Migrations.down()
  end
end
```
Then, execute `$ mix ecto.migrate` to run the newly created migration.

To set up config for this library, put the following line in your config file: 
```elixir
config :membrane_rtc_engine_timescaledb, repo: MyApp.Repo, cleanup_interval: 60 * 60, metrics_lifetime: 60 * 60 * 24
```
where 
 * `repo` (required) is a module in your project, that uses `Ecto.Repo`
 * `cleanup_interval` (default: 1 hour) is the number of seconds between database cleanups 
 * `metrics_lifetime` (default: 24 hours) is the number of seconds that must pass from creation before each metric can be deleted during cleanup

## Metrics visualisation with Grafana

Metrics stored in the database using `membrane_rtc_engine_timescaledb` can be simply visualized using Grafana.
To start the dashboard with RTC Engine metrics, mount configuration files, that are in `grafna/provisioning` to the Grafana docker container.
Eg. if you have cloned this repository in the `/root` directory, add `-v /root/membrane_rtc_engine_timescaledb/grafana/provisioning:/etc/grafana/provisioning` option to your `$ docker run`. Beyond that, you have also set four environment variables for your docker container
 * `DB_NAME` - name of the database, that you store your metrics in
 * `DB_USERNAME` - username used to log into the database
 * `DB_PASSWORD` - password used to log into the database
 * `DB_URL` - database URL in the form of `host:port`, eg. `localhost:5432`

If you want to take a look at some examples, see `deploy` step in any of the GitHub workflows in [membrane_videoroom](https://github.com/membraneframework/membrane_videoroom/tree/master/.github/workflows) with [docker-compose.yml](https://github.com/membraneframework/membrane_videoroom/blob/master/docker-compose.yml) file used by it.

## Running tests

To start tests, you have to run `$ docker-compose up` command, to have a running database docker container. To set up the database before tests, run `$ MIX_ENV=test mix ecto.reset` in second terminal window. Tests can be run with `$ mix test --include long_running` command.

## Copyright and License

Copyright 2020, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_template_plugin)

[![Software Mansion](https://logo.swmansion.com/logo?color=white&variant=desktop&width=200&tag=membrane-github)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_template_plugin)

Licensed under the [Apache License, Version 2.0](LICENSE)
