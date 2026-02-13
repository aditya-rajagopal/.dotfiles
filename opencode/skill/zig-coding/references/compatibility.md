# Zig Compatibility Notes

Zig evolves quickly. Always verify against the repository's actual compiler version.

## Version Check First

Run `zig env` and record `.version`.

## Practical API Differences

| Topic | Older Patterns (common in 0.11-0.14 repos) | Newer Patterns (0.15/0.16-dev style) |
|------|------|------|
| File APIs | `std.fs.cwd().openFile(...)` style | `std.Io.Dir.cwd().openFile(io, ...)` style |
| I/O context | implicit process/thread defaults | explicit `Io` threading/context in many APIs |
| ArrayList ergonomics | managed-style examples in older code | explicit allocator args on many mutating calls |

Do not rewrite a repo to latest style unless asked. Match local conventions.

## Safe Decision Rules

1. Prefer existing repo conventions over external snippets.
2. If adding new module code, follow the dominant style in touched area.
3. If style mix causes friction, add thin compatibility wrappers rather than broad churn.

## Validation Before Commit

- Example compiles in target repo version.
- No accidental API migration across unrelated files.
- Build/test commands for that repo still pass.
