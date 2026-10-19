# Toolchain, APIs, and build integration

Use this reference when compiler compatibility, dependencies, or test wiring is uncertain. Discovery should answer the current question, not survey the entire repository.

## Resolve the actual compiler

Look for the pin in repository instructions, CI, toolchain/version files, or wrapper commands. `build.zig.zon` may declare a minimum version; that is not necessarily the exact supported compiler. Compare with:

```sh
zig version
zig env
```

The environment identifies the compiler's stdlib and cache paths. Output format and field spelling can change; inspect the output before scripting its parsing. When `PATH` differs from the pin, use the repository's wrapper or matching executable. Do not silently upgrade the pin or rewrite APIs for the installed compiler. If the target is unavailable, do the source work that remains possible and state what could not be compiled.

## Resolve only the APIs being changed

Read matching stdlib declarations, contracts, and tests using search tools such as `rg`. Useful targets include `array_list.zig`, `multi_array_list.zig`, allocator implementations, and the relevant `Io/` or `fs/` modules. Check the receiver, allocator argument, ownership transfer, invalidation rules, and error set, not just the symbol's name.

Treat release families as hints, not an API table. Managed/unmanaged container methods, I/O contexts, clocks, and build-module APIs have changed independently. A tutorial marked “modern Zig” does not establish compatibility. If matching local source is unavailable, consult official documentation or source for the exact release/tag/commit; current `master` is not evidence for an older pin.

## Preserve the build graph

For import or build changes, inspect the relevant parts of `build.zig` and `build.zig.zon`:

- Named imports come from module wiring, generated modules, and dependencies.
- Relative Zig imports resolve relative to their containing source file, within the applicable module constraints.
- Test roots may require generated options, target settings, C libraries, or resources that a direct `zig test file.zig` omits.

Locate dependency source through the build configuration and reported cache paths; avoid guessing a universal cache layout. Prefer the repository's existing compatibility boundary over introducing a new wrapper for one inconvenient call.

## Verification commands are project-dependent

Read the project's documented test targets or inspect `zig build --help` when needed. Use its filtering mechanism for a focused test. `zig test file.zig --test-filter "case"` is suitable only when that file can be tested with the necessary module/options/link setup. `zig build test` is conventional, not a guaranteed target.

For implementation changes, check formatting with the pinned formatter, run relevant tests, and complete required repository checks. Build graph changes need coverage of affected targets/configurations. Add `-freference-trace` when diagnostics need it; it is not a separate correctness check.

On a failure, distinguish a defect in the change from an unavailable dependency, wrong compiler, or unrelated preexisting failure. Fix what the change caused and report other observed failures accurately. Successful compilation does not establish a runtime contract or performance improvement.
