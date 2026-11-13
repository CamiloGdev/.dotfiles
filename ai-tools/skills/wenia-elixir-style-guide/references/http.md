# HTTP: HTTP entry points

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| HTTP-1 | Must | Every endpoint has three stages: build domain input from body, path, query and headers; call **one** use case with no HTTP values; map the result to a status and body (ARCH-6). | review |
| HTTP-2 | Must | Let `Plug.Parsers` parse bodies. Map `Plug.Parsers.UnsupportedMediaTypeError` to 415 and malformed JSON to 400. No custom content-type validation layer. | review |
| HTTP-3 | Should | Name invalid request parameters in the error detail: `{:error, HttpErrors.invalid_req_params(), %{"limit" => "must be a positive integer"}}`. | review |
| HTTP-4 | Must | A route's `with` has one `else` clause that sends the error to `ErrorMapper` (CF-6). How errors are normalized before it is up to each service. | review |
| HTTP-5 | Must | Define each action's success status explicitly. Serialize through an established mapper or model serializer. Keep bodies and keys stable (ERR-12), and encode once. | review |
| HTTP-6 | Must | Add a catch-all route that maps to `resource_not_found`. | review |
| HTTP-7 | Must | Use `Plug.ErrorHandler` to log unexpected failures (OBS-8: no bodies, tokens or secrets) and return the mapped generic error. Never turn an expected business failure into an exception. | review |
| HTTP-8 | Must | Transport errors (`bad_request`, `resource_not_found`, `invalid_req_body`, …) live in `HttpErrors`, and business errors in `DomainErrors` (ERR-5). A new boundary-visible error gets an `ErrorMapper` clause with a unique code (ERR-6). | review |
| HTTP-9 | Must | Merge trusted path values into builder input when they identify the resource. Accept only the model variants the action allows. Business validation stays in models and use cases. | review |
| HTTP-10 | Must | Router tests: one `describe` per HTTP verb and resource path (TEST-23). Use `Plug.Test` with no HTTP mocks. Use cases are replaced through their ports (TEST-9). | review |

## Example (HTTP-1, HTTP-4)

```elixir
get "/assets/:id" do
  {body, status} =
    with {:ok, asset} <- GetAsset.handle(id) do
      {AssetMapper.to_map(asset), 200}
    else
      error -> ErrorMapper.map_error(error)
    end

  send_resp(conn, status, Jason.encode!(body))
end
```

`ErrorMapper.map_error/1` accepting the whole error tuple is a service choice. `AssetMapper` is illustrative.
