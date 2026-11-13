# ERR: Errors

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| ERR-1 | Must | A pure transformation returns its value, not `{:ok, value}`. Return tagged results only when the caller can act on the failure, and keep the protocol a port `@callback` declares. | review |
| ERR-2 | Must | A `?` function returns `true` or `false`, never `nil`, `:ok`, a tuple or another truthy value. | review |
| ERR-3 | Must | A broken internal invariant raises; don't turn it into an error tuple. `!` marks the raising variant and boot-time validation. | review |
| ERR-4 | Must | Public functions and port callbacks return failures as `{:error, DomainErrors.name()}`. Two shapes are also allowed: the `MapValidator` field-error map from a model's `new/1`, and the repository-validation 3-tuple `{:error, DomainErrors.name(), %{field => msg}}` (see SQL-3). Never return an inline atom, a string or a bare `:error`. | review |
| ERR-5 | Must | Add a new error as a function in the service's `DomainErrors`, or in `HttpErrors` when only the transport uses it. Never rename an error or change its atom. | review |
| ERR-6 | Must | Map errors to HTTP only in the `ErrorMapper`: one `error_info/1` clause per error with a unique code, a message and a status. Never build an error body or status in a router or use case. | review |
| ERR-7 | Must | Catch-all clauses belong only where external data enters: provider responses, webhook and queue payloads, AWS results, and `ErrorMapper`'s final fallback. They end in a domain error. Internal matches stay exhaustive. | review |
| ERR-8 | Must | Don't handle an error the callee can't return. Check its spec or port `@callback` first. | review |
| ERR-9 | Must | Use result matching, not `try`/`rescue`, for expected outcomes. Rescue only exceptions from external code that has no result API, next to that call, and convert them to a domain error. **SQL exception: see SQL-8.** | exslop:BlanketRescue, exslop:TryRescueWithSafeAlternative (explicit `try` only), review |
| ERR-10 | Must | No hand-written retry loops. Queue redelivery, provider redelivery and client retries own retrying. Where a retry is allowed, use `Wenia.Commons.Macros.Retry` (`autoretry/2`). | review |
| ERR-11 | Must | A refactor keeps error precedence, error atoms, response fields and optional-value semantics (omitted, `nil` or default). | review |
| ERR-12 | Must | Keep an existing route's statuses, error codes and response fields unless the task changes the contract. On webhooks, every unauthenticated outcome gets the same retryable status and body, and duplicates are acknowledged. | review |
| ERR-13 | Should | Keep return contracts predictable. When an option produces a fundamentally different result shape, make it a separate function. | review |
| ERR-14 | Should | Return repository and use-case results unchanged unless the caller owns a clearer contract. | review |
| ERR-15 | Must | Don't add `rescue`/`catch` (in code or tests) when the callee already handles the exception. | review |

## Examples

ERR-4: the allowed failure shapes.

```elixir
{:error, DomainErrors.asset_not_found()}
{:error, %{symbol: "can't be blank"}}                                # MapValidator, from new/1
{:error, DomainErrors.invalid_asset(), %{enabled: "must be true or false"}}  # repository validation
```

ERR-6: each error gets one mapper clause with a unique code.

```elixir
@asset_not_found DomainErrors.asset_not_found()

defp error_info(@asset_not_found), do: {%{"code" => "B00-001", "message" => "Asset not found"}, 404}
```
