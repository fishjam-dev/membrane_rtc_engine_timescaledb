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

To use `Membrane.RTC.Engine.TimescaleDB`, put the following line in your `config` file: 
```elixir
config :membrane_rtc_engine_timescaledb, repo: MyApp.Repo, cleanup_interval: 60 * 60, metrics_lifetime: 60 * 60 * 24
```
where 
 * `repo` (required) is a module in your project, that uses `Ecto.Repo`
 * `cleanup_interval` (default: 1 hour) is the number of seconds between database cleanups 
 * `metrics_lifetime` (default: 24 hours) is the number of seconds that must pass from creation before each metric can be deleted during cleanup

## Copyright and License

Copyright 2020, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_template_plugin)

[![Software Mansion](https://logo.swmansion.com/logo?color=white&variant=desktop&width=200&tag=membrane-github)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_template_plugin)

Licensed under the [Apache License, Version 2.0](LICENSE)
