# Code Evolution (Compression-Oriented)

This guidance is based on Casey Muratori's "Semantic Compression" and "Complexity and Granularity" essays.

## Core Loop

1. Write concrete code for the current case.
2. Duplicate when a second real case appears.
3. Compress only the proven common shape.

Do not start with speculative generic infrastructure.

## Rule of Three (Practical)

- First occurrence: keep concrete.
- Second occurrence: copy/adapt intentionally.
- Third occurrence: extract the shared operation.

This reduces wrong abstractions and preserves velocity.

## Continuous Granularity

When you add higher-level helpers, do not remove lower-level escape hatches.

Bad outcome: helper is convenient for one case but blocks nearby variants.

Good outcome: layered APIs where:

- high-level helpers cover common operations,
- mid-level helpers expose meaningful control,
- low-level primitives remain available for edge cases.

## Naming and Shape

- Name by action and domain effect (`validate_header`, `integrate_velocity`).
- Avoid vague buckets (`manager`, `handler`, `util`).
- Keep function signatures specific and auditable.

## Refactor Triggers

Refactor when at least one is true:

- repeated code shape appears in 3+ places,
- bug fixes need touching multiple near-identical blocks,
- shared invariant is hard to keep synchronized.

Do not refactor purely for aesthetic uniformity.

## Example Pattern

```zig
fn parseLogin(req: Request) !Creds { ... }
fn parseSignup(req: Request) !Signup { ... }
// After repeated overlap appears in several routes:
fn parseUserFields(req: Request) !struct { user: []const u8, pass: []const u8 } { ... }
```

The extracted function should match observed reality, not desired architecture.

## Review Checklist

- Abstractions are justified by repeated concrete use.
- New helper does not remove lower-level flexibility.
- Names reflect behavior, not organizational role.
- Refactor reduces total maintenance cost, not just line count.
