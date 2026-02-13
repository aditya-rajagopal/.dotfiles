# Zig Environment and Module Discovery

Use this when you need to confirm stdlib APIs or trace module origin in a repo.

## Step 1: Inspect `zig env`

Run:

```bash
zig env
```

Key fields:

- `version`: Zig version (decides API surface).
- `std_dir`: stdlib source root.
- `global_cache_dir`: downloaded dependency cache.

## Step 2: Confirm API in `std_dir`

Before writing code, verify symbols in the local stdlib source.

High-value files:

- `std.zig`
- `array_list.zig`
- `multi_array_list.zig`
- `heap/arena_allocator.zig`
- `Io/Dir.zig`, `Io/File.zig`, `Io/Reader.zig`, `Io/Writer.zig`, `Io/Threaded.zig`
- `time.zig`

For OpenCode agents, prefer `Read`/`Grep`/`Glob` tools for this inspection.

## Step 3: Resolve Project Modules

Inspect:

1. `build.zig.zon` for dependency declarations.
2. `build.zig` for module wiring (`addModule`, `createModule`, `dependency`).

Then map imports:

- `@import("std")` -> stdlib.
- `@import("name")` -> module wired by build graph.
- `@import("./x.zig")` -> relative file module.

## Step 4: Locate Dependency Source

Use dependency hash/path from `build.zig.zon` and inspect under `global_cache_dir`.
Prefer reading files through tooling, not assumptions about package layout.

## Common Pitfalls

- Assuming examples from a different Zig version compile unchanged.
- Mixing old `std.fs`-style and newer `std.Io` APIs without checking repo version.
- Guessing build graph imports without reading `build.zig`.

## Quick Checklist

- `zig env` captured.
- Version compatibility checked (`compatibility.md`).
- Required std symbols confirmed in local std source.
- Import origin traced via `build.zig`/`build.zig.zon`.
