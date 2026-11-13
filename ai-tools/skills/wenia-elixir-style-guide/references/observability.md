# OBS: Observability

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| OBS-1 | Must | Choose the level by outcome: `info` for expected outcomes, `warning` for handled degradation or rejected input, `error` for failures that need action. `debug` only for diagnostics. | review |
| OBS-2 | Must | A new Logger metadata key is added to the `config :logger` formatter `metadata:` list in the same diff, or it never reaches the logs. | credo:MissedMetadataKeyInLoggerConfig (reads compile-time Logger config, not `runtime.exs`; `metadata: :all` disables it; falls back to `:console` metadata when `:default_formatter` sets none, see OBS-15) |
| OBS-3 | Should | Give each log a stable `operation:` naming the step (e.g. `"market_data.refresh_failed"`). | review |
| OBS-4 | Should | Logs on a request or message path carry `correlation_id`. | review |
| OBS-5 | Must | Logger metadata belongs to one process. Tasks, GenServer callbacks and Broadway callbacks take the correlation id from their arguments (`Wenia.Commons.Macros.Context`). | review |
| OBS-6 | Must | A branch that absorbs a failure (acknowledges, retains, retries or falls back) logs it. | review |
| OBS-7 | Should | An alertable failure logs at `error` with its `DomainErrors` code as `error_code:` and emits the matching metric. | review |
| OBS-8 | Must | Never log or emit raw provider bodies, headers, signatures, credentials, keys, tokens, wallet addresses or end-user identifiers. Call `inspect/1` only on values known to be free of them, such as `DomainErrors` atoms. Never `inspect(error)` a transport or decode result. | review |
| OBS-9 | Should | Emit metrics only through the service's single metrics module. Event and metadata names are a contract with the exporter. | review |
| OBS-10 | Should | Metric metadata holds bounded values (outcome, kind), never ids, amounts or payload fields. Measurement keys carry their unit. | review |
| OBS-11 | Should | A change that adds an alert condition also adds the metric that shows whether it holds. | review |
| OBS-12 | Should | Log a failure once, where it's handled. Don't log the same failure at every layer. | review |
| OBS-13 | Must | Committed code logs through `Logger`. Remove `IO.inspect/2`, `IO.puts/1` and `dbg/1` before merge. | credo:IoInspect, credo:Dbg, credo:IoPuts (enable) |
| OBS-14 | Must | A service being changed adopts the Wenia structured logs standard: JSON logs with the common fields `service`, `squad`, `env` and `category`, and a `correlation_id` propagated across services. The schema lives in the [Structured Logs Standard](https://app.notion.com/p/wenia/Est-ndar-de-Logs-Estructurados-Wenia-3aa66750c1aa81b89cf2fe8cfa622b68) and its [adoption guide](https://app.notion.com/p/wenia/Gu-a-de-uso-Est-ndar-de-Logs-Estructurados-de-Wenia-3df66750c1aa81b5914bc670bb5ab01f), not here. | review |
| OBS-15 | Must | On Elixir 1.15 and later, configure log format and metadata through `config :logger, :default_formatter`, never `config :logger, :console`, which is ignored once the console backend is gone. When `lager` is in the dependency tree, set `config :lager, error_logger_redirect: false`; otherwise lager replaces Logger's `:default` handler and logs disappear without an error. Don't set `error_logger_whitelist: [Logger.ErrorHandler]`; that module no longer exists. Verify that `:logger.get_handler_ids()` includes `:default`. | review |
