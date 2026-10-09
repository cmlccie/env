---
paths:
  - "**/*.rs"
---

# Rust style

Write Rust the way I do: functional, declarative, and as simple as possible, only as
sophisticated as necessary. When two designs work, pick the one with fewer concepts. A
project's own CLAUDE.md wins where it is more specific.

## Design

- Solve today's problem with concrete types. Add a trait, generic, macro, or explicit
  lifetime when a second real use needs it; each one costs every future reader.
- Model the domain with plain structs and enums so invalid states can't be represented
  (`enum CacheMode { Auto, Refresh, Offline }` instead of two bools).
- Parse at the boundary (`FromStr`, serde, clap value parsers) into typed values; the core
  works on types, not strings.
- Keep functions pure. Inject effects (DNS resolver, env lookup, clock) as plain function or
  closure parameters, e.g. `from_env(lookup: impl Fn(&str) -> Option<String>)`, so tests
  pass a fake. Reach for trait objects only when a closure won't do.
- Use a `FooBuilder` for config with many optional fields; `Default` holds the defaults.
- Take borrowed, general inputs (`&str`, `&[T]`, `impl IntoIterator<Item = S>`,
  `AsRef<Path>`, `&mut impl Write`); own data in structs. Borrow zero-copy where it's
  natural (serde `&'a str`). Restructure rather than `.clone()` to satisfy the borrow checker.
- Library crates: keep modules private and re-export the public API from `lib.rs`.

## Expressions

- Prefer iterator chains (`map`, `filter_map`, `any`, `all`, `sum`, `collect`) over loops
  with mutable accumulators. A `for` loop is fine for side effects or tangled early exits.
- Bind results of expressions: `let x = match ...` / `if ...`. Use `bool::then`,
  `Option::{map, or, unwrap_or}`, `is_some_and`, `let ... else`, and slice patterns.
- Express decision tables as a `match` on a tuple: `match (refresh, offline) { (true, _) => ...`.
- Dispatch with data: a `match` that returns a function, or an array of predicates folded
  with `.iter().all(|f| f(self, x))`.
- Collect fallible iterators directly: `.collect::<Result<BTreeSet<_>>>()?`.
- Name things fully (`network_border_group`, not `nbg`); short names are fine in tiny
  closures (`|n|`). Add type aliases when they carry domain meaning (`type Stone = u64;`).
- Replace magic values with named `const`s, and annotate units inline:
  `cache_time: 24 * 60 * 60, // 24 hours`.
- Prefer `std` (`std::sync::LazyLock`, not `lazy_static`). Add a dependency only when it
  removes real complexity; favor the mainstream crates (clap derive, serde, thiserror,
  log, comfy-table).

## Errors and I/O

- Libraries: one `thiserror` enum, `#[non_exhaustive]`, lowercase messages without a
  trailing period, `#[source]` for causes, and third-party errors boxed so their types stay
  out of the public API. Export `pub type Result<T>`.
- Binaries: `main() -> ExitCode` calling `run() -> Result<_, Box<dyn Error>>` (or `anyhow`);
  print the error, its `source()` chain, and a hint when there's an obvious fix.
- Propagate with `?` and `ok_or_else`. Reserve `unwrap`/`expect` for tests, examples,
  puzzle-input parsing, and true invariants (the `expect` message states the invariant).
- Write output to `&mut impl Write`, not `println!`, so it's testable and a closed pipe
  (`| head`) is handled instead of panicking. Treat `BrokenPipe` as success.
- Log with the `log` macros (stderrlog in binaries). A library logs returned errors at
  warn/debug since the caller reports them.

## Layout and comments

- Divide every file into sections with banner comments, three levels deep (top level spans
  to column 99, second to 88, third is indented inside `impl` blocks):

  ```rust
  /*-------------------------------------------------------------------------------------------------
    Client
  -------------------------------------------------------------------------------------------------*/

  /*--------------------------------------------------------------------------------------
    Client Implementation
  --------------------------------------------------------------------------------------*/

  impl Client {
      /*-------------------------------------------------------------------------
        Getters
      -------------------------------------------------------------------------*/
  }
  ```

- File order: `use` lines, then public items first and helpers after, then
  `#[cfg(test)] mod tests` under a `Unit Tests` banner at the bottom.
- Imports: explicit `crate::` paths, one item set per `use`; globs only for `use super::*`
  in tests.
- Doc-comment every public item in one or two plain sentences saying what it is or does.
  Give each public API example a doctest (hide setup with `# fn main() -> Result<()> {`).
- Inside functions, use short phrase comments that label steps (`// Get AWS IP Ranges`)
  and comments that explain why. Skip comments that restate the code.

## Tests

- Unit tests live in the module; CLI tests in `tests/` run the binary (assert_cmd) and
  assert exact output.
- Keep tests deterministic and offline: small real fixtures, loopback servers, injected
  fakes, `tempfile`. Never mutate process env vars, so tests stay parallel-safe.
- Build test data with tiny helper functions (`fn search(target, networks) -> Search`).
- Name tests `test_<behavior>` and compare whole values with `assert_eq!`.

## Done means

- Run the repo's checks (prefer its Makefile targets): `cargo fmt`,
  `cargo clippy --all-targets -- -D warnings`, rustdoc with `-D warnings`, and `cargo test`.
- Use Rust 2024 edition with `rust-version` set in `Cargo.toml`.
- Write Conventional Commits (`feat(cli): ...`, `fix!: ...`), one focused change each,
  because release tooling builds the changelog and version from them.
