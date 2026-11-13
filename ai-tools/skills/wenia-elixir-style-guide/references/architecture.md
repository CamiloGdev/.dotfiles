# ARCH: Architecture

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| ARCH-1 | Must | Business decisions (classification, state transitions, deduplication, publication policy) live in use cases or models. Adapters only translate IO and protocol. Entry points only parse, call the domain and reply. | review |
| ARCH-2 | Must | Each external system sits behind a `<App>.Domain.Ports.*` behaviour whose callbacks use domain types. Provider field names, status codes and IDs stop at the adapter. Keep ports minimal, and change one only when its contract can't express the need. | review |
| ARCH-3 | Must | A port implementation declares `@behaviour` for its one port and marks each callback, including each `defdelegate`, with `@impl Port`. | compiler, credo:ImplTrue (enable), review |
| ARCH-4 | Must | Domain code reaches an adapter only through `adapter_for/1` or `adapter_for/2` from `Wenia.Commons.Macros.ModuleInyector`. A port with one adapter uses `mode: :one_adapter_per_port` with `config :<otp_app>, Port, adapter: Adapter`, and code calls `adapter_for(Port)`. A port with several adapters uses `mode: :multiple_adapters_per_port` with `config :<otp_app>, Adapter, port: Port, adapter_id: :id` for each adapter, and code calls `adapter_for(Port, :id)`. New code uses these `mode:` lists, not the older plain port list (`use ModuleInyector, [Port]`). Never call a concrete adapter. | review |
| ARCH-5 | Must | **Scoped:** New services (created after this rule set is adopted) use SNS, SQS and EventBridge only. Existing RabbitMQ services (each says so in its `AGENTS.md`) are not in violation. Don't add *new* AMQP flows to them without owner sign-off. | review |
| ARCH-6 | Must | Entry points build the request model (or CoreLib model) and pass the validated value to the use case. Use cases never take raw params, `Plug.Conn` or JSON. | review |
| ARCH-7 | Must | Each channel owns its namespace (one namespace per channel: HTTP, WebSocket, a queue). No channel embeds another's transport logic. | review |
| ARCH-8 | Must | Routers keep `plug(:match)` before `plug(:dispatch)`, skip body parsing where a raw body is needed for signatures, and send every error through `ErrorMapper`. | review |
| ARCH-9 | Must | A module has one purpose. A model holds its struct, constructor and pure queries. A vocabulary module holds constants. No module mixes parsing, formatting and IO. | review |
| ARCH-10 | Must | Pure transformations are plain functions. Effects happen in adapters, through a use case's port calls. A process models runtime state, concurrency or isolation, never layout. | review |
| ARCH-11 | Must | Every process starts under the `<App>.Application` tree. One-off async work runs under a `Task.Supervisor`. Never use `spawn`, `Task.start` or an unlinked `GenServer.start`. | `.reach.exs` calls[:forbidden] (Kernel.spawn*, Process.spawn, :erlang.spawn*, Task.start, GenServer.start, Agent.start; an imported `spawn`/`spawn_link` isn't a remote call and isn't caught), review |
| ARCH-12 | Must | Use a GenServer or Agent only for owned state, serialized access or scheduled work. Only the owning module calls `GenServer` functions on its name; others use its public API. | review |
| ARCH-13 | Must | Add concurrency only for a measured need. No task around one item, and no task per message inside Broadway. | review |
| ARCH-14 | Must | Webhook, queue and publication paths are idempotent. A redelivery produces no second effect: claim it through a dedup store or conditional write before acting, and acknowledge duplicates. | review |
| ARCH-15 | Should | A message, call or task closure carries only the data the receiver needs, never a whole `Plug.Conn` or raw payload. | review |
| ARCH-16 | Should | A use case exposes only `handle/N`. | review |
| ARCH-17 | Must | A use case validates before any irreversible side effect, and makes transaction, idempotency and side-effect order explicit. | review |

## Example

ARCH-4 and ARCH-16: the use case reaches its port through the injector and exposes only `handle/1`.

```elixir
defmodule MyService.Domain.UseCases.GetAsset do
  use Wenia.Commons.Macros.ModuleInyector, [
    [mode: :one_adapter_per_port, ports: [MyService.Domain.Ports.AssetsRepository]]
  ]

  alias MyService.Domain.Ports.AssetsRepository

  def handle(id), do: adapter_for(AssetsRepository).get(id)
end
```

Illustrative only.
