# Zig Coding References

Entrypoint for routing Zig implementation tasks.

## Quick Router

| Need | Read |
|------|------|
| Start a Zig task safely | `workflow.md` |
| Confirm version/API differences | `compatibility.md` |
| Allocator/lifetime design | `memory-management.md` |
| MultiArrayList and memory layout | `data-layout.md` |
| Strong correctness contracts | `tigerstyle-safety.md`, `assert-guidelines.md` |
| Refactor strategy | `code-evolution.md` |
| Performance and measurement | `performance.md` |
| File and directory operations | `file-io.md` |
| stdlib/module discovery | `zig-environment.md` |
| Pitfall scan | `anti-patterns.md` |
| Final merge checks | `review-gate.md` |
| Source provenance | `sources.md` |

## Typical Reading Order

1. `workflow.md`
2. `compatibility.md`
3. Topic-specific file(s)
4. `assert-guidelines.md` for boundary checks

## Design Bias

- Safety over speed over convenience.
- Explicit allocator and ownership flow.
- Compression-oriented abstraction (concrete first).
- Performance-aware iteration and measurement.
