# PB: Provider boundary (HTTP providers, DynamoDB, Redis)

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| PB-1 | Must | Call provider HTTP APIs only through `Wenia.Commons.Clients.Http.HttpClient`, passing the port's `cb_threshold` and `cb_timeout_sec`. Never make requests with Finch, Req or HTTPoison directly. Pattern matching on their structs or values (for example `%Finch.Response{}`) to process results is allowed. | `.reach.exs` calls[:forbidden] on the Finch, Req and HTTPoison request functions (not whole modules; patterns below), review |
| PB-2 | Must | Keep three steps apart: classify the HTTP status, decode the body, project the domain result. Extract a helper only for a real decision. | review |
| PB-3 | Must | Status precedence lives only in the classifier. Success decoders only see 2xx bodies. When a non-2xx response carries a body the code needs, such as a provider error code, the classifier passes it to an error decoder. That decoder checks the fields it uses (PB-4) and maps them to a domain error (PB-6, PB-7). | review |
| PB-4 | Must | Provider values are untrusted. In the decoder head, check the type and emptiness of every field you use; a typespec or map pattern doesn't validate values. Helpers that receive decoded values don't re-check them. | review |
| PB-5 | Should | An absent or `null` optional provider field omits its key from the result. A present value keeps its type check. | review |
| PB-6 | Must | Every classifier and decoder ends with a fallback clause (ERR-7). Map transport errors, undecodable bodies and unknown shapes to a domain error. Never return a `%Finch.Response{}`, a client reason or a decoded provider error through the port. | review |
| PB-7 | Must | Never put a provider body, decoded provider error, API key, secret, token or PEM in a returned error, an `ErrorMapper` detail, a log or log metadata. Log the HTTP status and the domain error code. For exceptions, log only the exception module. | review |
| PB-8 | Must | Provider field names, statuses and event names stay in that provider's adapter. Decoders return canonical domain names. | review |
| PB-9 | Should | Provider event types are open values. Retain and record an unknown event type; don't fail on it. | review |
| PB-10 | Should | Don't combine credential checks, selection and response mapping in one condition. Each is its own step. | review |
| PB-11 | May | DynamoDB adapters: when converting models with `to_json_map/2`, prefer `keys_option: :underscore`. | review |
| PB-12 | Must | Keep retries, timeouts, pagination and protocol details inside the adapter or its client. Don't add infrastructure-specific callbacks to a domain port. | review |
| PB-13 | Should | Events a service publishes stay vendor-neutral: they carry domain fields, never a provider's raw payload or field names. | review |

PB-1 `.reach.exs` patterns, checked against Finch 0.24.0, Req 0.7.5 and HTTPoison 3.0.0: forbid calls from `<App>.**` to `Finch.request*`, `Finch.stream*`, `Finch.async_request`, `Req.get`, `Req.get!`, `Req.post*`, `Req.put*`, `Req.patch*`, `Req.delete*`, `Req.head*`, `Req.request*`, `Req.run*`, `Req.async_request*`, `Req.Request.run*`, `HTTPoison.get*`, `HTTPoison.post*`, `HTTPoison.put*`, `HTTPoison.patch*`, `HTTPoison.delete*`, `HTTPoison.head*`, `HTTPoison.options*` and `HTTPoison.request*`. Add `except:` only for a repo-owned HTTP client wrapper. `Finch.build` and `Req.new` only build a request and stay allowed. Don't use `Finch.*`: it also matches type references such as `Finch.Response.t()` in a `@spec`.

## Example (PB-2, PB-6, PB-7)

```elixir
defp handle_response({:ok, %Finch.Response{status: status, body: body}}) when status in 200..299 do
  case Jason.decode(body) do
    {:ok, payload} -> decode_response(payload)
    {:error, _} -> {:error, DomainErrors.unexpected_external_provider_response()}
  end
end

defp handle_response({:ok, %Finch.Response{status: status}}) do
  Logger.error("Market data provider returned an unexpected status",
    status: status, error_code: DomainErrors.unexpected_external_provider_response())
  {:error, DomainErrors.unexpected_external_provider_response()}
end

defp handle_response({:error, _transport_reason}) do
  Logger.error("Market data provider request failed",
    error_code: DomainErrors.invalid_external_provider_response())
  {:error, DomainErrors.invalid_external_provider_response()}
end
```

The error names come from the service's `DomainErrors`.
