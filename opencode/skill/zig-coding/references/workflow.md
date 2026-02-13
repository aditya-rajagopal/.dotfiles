# Agent Workflow for Zig Tasks

Use this checklist for reliable implementation and review.

## 1) Discover

- Capture `zig env` and version.
- Read `build.zig` and `build.zig.zon`.
- Identify whether codebase uses modern `std.Io`, legacy `std.fs`, or both.

## 2) Plan by Risk

- **Low risk**: local utility, no persistent state.
- **Medium risk**: parser/state transitions/allocator ownership.
- **High risk**: protocol/storage/money-critical or hot-path core.

Pick profile:

- low -> `baseline`
- medium -> `strict`
- high -> `tigerstyle-critical`

## 3) Implement

- Make memory behavior and ownership explicit.
- Apply reserve-first before infallible mutation loops.
- Add assertions for critical invariants.
- Keep loops bounded or budgeted.

## 4) Validate

- Run focused tests first.
- Run full suite/build target.
- If performance-sensitive, measure before/after.

Suggested command sequence:

```bash
zig test path/to/file.zig --test-filter "target case"
zig build test
```

## 5) Review Gate

- API shape reflects ownership and failure modes.
- Assertions and typed errors are separated correctly.
- Version-specific API usage is confirmed in local stdlib.
- Public behavior or perf assumptions are documented.
- Run through `anti-patterns.md` and `review-gate.md`.

## 6) Escalation Triggers

Escalate to stricter review if any are true:

- touched stateful protocol/persistence code,
- introduced unsafe/cast-heavy code,
- changed hot-loop or layout assumptions,
- changed allocator topology or ownership boundaries.
