# Go Changes After the Model Knowledge Cutoff (Go 1.25 – Go 1.27)

The model knows Go up to about Go 1.24. This file lists what came after.
Sources: `$(go env GOROOT)/api/go1.2{5,6,7}.txt`, `doc/go_spec.html`, `doc/godebug.md`, and `go doc`.
Only use a feature if the `go` directive in `go.mod` is at least the version listed.
If something here is unclear, check with `go doc <pkg>.<Symbol>`.

## Language

| Version | Change |
| ------- | ------ |
| 1.26 | `new(expr)` allocates a variable set to the value of `expr`, for example `new(42)` or `new(time.Now())`. Use it instead of helpers like `ptr(v)` or `&[]T{v}[0]`. |
| 1.27 | Methods may declare their own type parameters (generic methods): `func (r *Rand) N[Int intType](n Int) Int`. |
| 1.27 | Function type inference works in all assignment contexts. A generic function can be assigned to a variable, field, or parameter of a function type without explicit type arguments. |
| 1.27 | Keys in struct composite literals may be any field selector, including promoted fields: `T{Embedded.Field: v}` or `T{Field: v}` for a promoted `Field`. |

## Testing

| Version | API | Use |
| ------- | --- | --- |
| 1.25 | `testing/synctest.Test(t, func(t *testing.T))`, `synctest.Wait()` | Test concurrent and time-based code with a fake clock in an isolated "bubble". Replaces the 1.24 `GOEXPERIMENT=synctest` `Run` API. |
| 1.27 | `synctest.Sleep(d)` | Same as `time.Sleep(d)` followed by `synctest.Wait()`. Prefer it in bubbles. |
| 1.25 | `t.Attr(key, value)` | Emits a test attribute into the test log / `-json` output. |
| 1.25 | `t.Output() io.Writer` | Writer that goes to the test log, with indentation. |
| 1.26 | `t.ArtifactDir() string` | Directory for test output files. Kept when `go test -artifacts` is used, temporary otherwise. |
| 1.27 | `httptest.NewTestServer(t, handler)` | Test server on an in-memory network, closed automatically at test end. Prefer it over `httptest.NewServer` + `defer srv.Close()`. |
| 1.26 | `testing/cryptotest.SetGlobalRandom(t, seed)` | Deterministic randomness for crypto in tests. |
| 1.25 | `testing/fstest.MapFS` implements `fs.ReadLinkFS` | Symlinks in fake file systems. |

## Concurrency and Runtime

- 1.25: `sync.WaitGroup.Go(func())` replaces `wg.Add(1); go func() { defer wg.Done(); ... }()`.
- 1.25: `GOMAXPROCS` respects cgroup CPU limits on Linux and updates itself when limits change. `runtime.SetDefaultGOMAXPROCS()` restores this default. Do not add `go.uber.org/automaxprocs` to new code.
- 1.25: `runtime/trace.NewFlightRecorder(cfg)` keeps a rolling in-memory trace. Call `WriteTo` after an interesting event.
- 1.26: The Green Tea garbage collector is the default.

## Errors

- 1.26: `errors.AsType[E error](err) (E, bool)` is the type-safe form of `errors.As`.
  Prefer `if pe, ok := errors.AsType[*fs.PathError](err); ok { ... }` over declaring a target variable.

## New Packages

- 1.26: `crypto/hpke` implements Hybrid Public Key Encryption (RFC 9180), including post-quantum KEMs.
- 1.27: `crypto/mldsa` implements ML-DSA post-quantum signatures.
- 1.27: `uuid` (import path `"uuid"`) provides `uuid.New()`, `NewV4()`, `NewV7()`, `Parse`, `MustParse`, `Nil()`, `Max()`, and `UUID.Compare`.
  Prefer it over `github.com/google/uuid` in new code.
- 1.27: `encoding/json/v2` and `encoding/json/jsontext` are stable. In 1.25 and 1.26 they needed `GOEXPERIMENT=jsonv2`.
  - `json.Marshal(v, opts...)`, `json.Unmarshal(data, &v, opts...)`, `json.MarshalWrite(w, v)`, `json.UnmarshalRead(r, &v)`.
  - Streaming: `json.MarshalEncode(enc, v)`, `json.UnmarshalDecode(dec, &v)` with `jsontext.Encoder` / `jsontext.Decoder`.
  - Custom types: implement `MarshalJSONTo(*jsontext.Encoder) error` and `UnmarshalJSONFrom(*jsontext.Decoder) error`.
  - Per-call custom codecs: `json.WithMarshalers(json.MarshalFunc(...))`, `json.WithUnmarshalers(json.UnmarshalFunc(...))`.
  - Options: `json.RejectUnknownMembers(true)`, `json.Deterministic(true)`, `json.StringifyNumbers(true)`, `json.FormatNilSliceAsNull(true)`, `jsontext.Multiline(true)`, `jsontext.WithIndent("  ")`.
  - v2 defaults differ from v1: names match case-sensitively, nil slices and maps encode as `[]` and `{}`, invalid UTF-8 and duplicate names are errors.
  - `encoding/json` (v1) is now built on v2. It accepts `json.Options` and legacy option helpers such as `json.DefaultOptionsV1()`.

## Standard Library Additions

### Strings and Bytes

- 1.26: `bytes.Buffer.Peek(n)` returns the next `n` bytes without advancing.
- 1.27: `strings.CutLast(s, sep)` and `bytes.CutLast` split around the last `sep`.

### Logging

- 1.25: `slog.GroupAttrs(name, attrs...)` builds a group `Attr` from `[]slog.Attr`.
- 1.25: `slog.Record.Source()` returns the source location.
- 1.26: `slog.NewMultiHandler(handlers...)` sends each record to several handlers.

### Networking and HTTP

- 1.25: `http.CrossOriginProtection` provides CSRF protection with `Sec-Fetch-Site` and `Origin` checks. Use `http.NewCrossOriginProtection().Handler(h)`.
- 1.26: `http.Transport.NewClientConn(ctx, scheme, addr)` returns a `*http.ClientConn` that you manage yourself.
- 1.26: `net.Dialer.DialTCP`, `DialUDP`, `DialIP`, and `DialUnix` take a context and `netip` addresses.
- 1.26: `httputil.ReverseProxy.Director` is deprecated. Use `Rewrite`.
- 1.26: `netip.Prefix.Compare`.
- 1.27: `url.URL.Clone()` and `url.Values.Clone()`.
- 1.27: `http.Server.MaxHeaderValueCount` (default `http.DefaultMaxHeaderValueCount` = 500) and `http.Server.DisableClientPriority`.
- 1.26: `net/url.Parse` rejects colons in hosts outside brackets, for example `http://localhost:1:2`.

### Files and OS

- 1.25: `os.Root` gained `Chmod`, `Chown`, `Chtimes`, `Lchown`, `Link`, `MkdirAll`, `ReadFile`, `Readlink`, `RemoveAll`, `Rename`, `Symlink`, `WriteFile`.
  Use `os.OpenRoot(dir)` for path-traversal-safe file access.
- 1.25: `io/fs.ReadLinkFS`, `fs.ReadLink`, `fs.Lstat`.
- 1.26: `os.Process.WithHandle(func(uintptr))` and `os.ErrNoHandle`.

### Reflection and Generics Helpers

- 1.25: `reflect.TypeAssert[T](v reflect.Value) (T, bool)` avoids `v.Interface().(T)` allocations.
- 1.26: Iterators on reflection: `reflect.Type.Fields()`, `Methods()`, `Ins()`, `Outs()`, and `reflect.Value.Fields()`, `Methods()`.
- 1.27: `hash/maphash.Hasher[T]` and `maphash.ComparableHasher[T]` define hash and equality for custom hash containers.
- 1.27: `(*rand.Rand).N` in `math/rand/v2` is now a generic method.
- 1.27: `big.Int.Divide(x, y, mode)` with rounding modes `big.Round`, `Trunc`, `Floor`, `Ceil`.

### Hashing and Crypto

- 1.25: `hash.Cloner` and `hash.XOF` interfaces. `sha3.SHA3` and `maphash.Hash` implement `Clone`.
- 1.25: `crypto.MessageSigner` and `crypto.SignMessage`.
- 1.25: `ecdsa.ParseRawPrivateKey`, `ecdsa.ParseUncompressedPublicKey`, `PrivateKey.Bytes()`, `PublicKey.Bytes()`.
- 1.26: `ecdsa.PrivateKey.D` and `PublicKey.X` / `Y` are deprecated. Use the `Bytes`/`Parse*` functions.
- 1.26: `rsa.EncryptPKCS1v15`, `DecryptPKCS1v15`, and `DecryptPKCS1v15SessionKey` are deprecated. Use OAEP (`rsa.EncryptOAEPWithOptions` is new).
- 1.26: Most `crypto/...` APIs ignore the caller-supplied random `io.Reader` (`GODEBUG=cryptocustomrand=1` reverts). Use `testing/cryptotest.SetGlobalRandom` for determinism in tests.
- 1.26: TLS enables `SecP256r1MLKEM768` and `SecP384r1MLKEM1024` hybrid post-quantum key exchange by default.
- 1.26: `crypto/fips140.Enforced()`, `Version()`, `WithoutEnforcement(f)`.
- 1.27: `tls.Config.Rand` is deprecated. ML-DSA is supported in `crypto/tls` and `crypto/x509`.
- 1.25: TLS 1.2 no longer allows SHA-1 signatures (`GODEBUG=tlssha1=1` reverts).

### Tooling APIs (`go/*`)

- 1.25: `go/ast.PreorderStack`, `go/types.Var.Kind()`, `go/types.LookupSelection`. `go/parser.ParseDir` and `ast.Package` helpers are deprecated.
- 1.26: `go/ast.Directive` and `ast.ParseDirective` parse `//tool:name args` comments.
- 1.27: `go/types.Hasher` and `HasherIgnoreTags` for type-keyed hash maps.

## Removed GODEBUG Settings in 1.27

`gotypesalias`, `tlsunsafeekm`, `tlsrsakex`, `tls3des`, `tls10server`, `x509keypairleaf`, and `asynctimerchan` are gone.
Code can no longer opt back into the old behavior. Remove them from `//go:debug` lines and `godebug` blocks in `go.mod`.

## Tooling: `go fix` Modernizers

`go fix` runs analyzers that rewrite old code to modern idioms. Run `go fix ./...` (or `go fix -diff ./...` to preview) after you raise the `go` version in `go.mod`.
Available analyzers include:

- `any`, `minmax`, `rangeint`, `forvar`, `mapsloop`, `slicescontains`, `slicessort`, `slicesbackward`
- `stringscut`, `stringscutprefix`, `stringsseq`, `stringsbuilder`
- `errorsastype` (`errors.As` → `errors.AsType`), `newexpr` (`new(expr)`), `waitgroupgo` (`wg.Go`)
- `testingcontext` (`context.WithCancel` → `t.Context()` in tests)
- `omitzero` (`omitempty` → `omitzero` for struct fields), `reflecttypefor`, `atomictypes`, `embedlit`
- `inline`: applies `//go:fix inline` directives. Mark a deprecated wrapper function with `//go:fix inline` so callers are rewritten automatically.

See the list for the installed version with `go tool fix help`.
