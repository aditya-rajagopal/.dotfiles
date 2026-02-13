# Zig Review Gate

Use before merge for non-trivial Zig changes.

## Correctness Gate

- Invariants are explicit (asserts or typed checks).
- Assertion vs runtime-error boundary is intentional.
- External input paths fail safely without assert abuse.
- Lifetime and ownership model is clear at call sites.

## Safety Gate

- No newly unbounded loops/queues without budgets.
- No recursion that scales with untrusted input depth.
- Unsafe casts/pointer operations have nearby justification checks.
- High-risk properties have paired assertions across boundaries.

## Performance Gate

- No hidden allocations introduced on hot path.
- Data layout matches access pattern where throughput matters.
- Claimed optimizations have before/after measurement notes.
- Complexity increase is proportional to measured benefit.

## Compatibility Gate

- Zig version assumptions verified (`zig env`).
- stdlib APIs match local compiler and repo conventions.
- Build graph/import wiring changes checked in `build.zig` and `build.zig.zon`.

## Validation Gate

- Focused tests for changed behavior pass.
- Full test/build command for repo pass.
- Public behavior changes are documented.
