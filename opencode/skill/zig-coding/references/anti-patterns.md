# Zig Anti-Patterns

Common mistakes that hurt safety, correctness, or performance.

## Memory

- Hidden allocation in utility functions without clear ownership contract.
- Mixing fallible allocation and mutation in the same inner loop.
- Long-lived references to growable container elements.
- Ad-hoc allocation churn in deterministic/hot paths.

Prefer allocator-explicit APIs, reserve-first mutation, and stable handles.

## Data Layout

- AoS containers when loops only touch one or two fields.
- Pointer-chasing object graphs in latency-sensitive loops.
- Ignoring struct padding and alignment in packed/high-volume structures.

Prefer SoA/MultiArrayList where access patterns justify it.

## Safety and Control Flow

- Assertions used for normal runtime errors.
- Unbounded loops over external input without guardrails.
- Recursive runtime traversal on untrusted/deep input.
- Large compound conditions that obscure case coverage.

Prefer typed errors, explicit bounds, and split conditions.

## Abstraction and Naming

- Generic buckets: `manager`, `handler`, `util`.
- Premature generic interfaces before real repeated use.
- Removing lower-level APIs when adding high-level helpers.

Prefer action/domain names and compression-oriented layering.

## Performance

- Micro-optimizing before measuring bottlenecks.
- Keeping benchmark code that allows dead-code elimination.
- Claiming SIMD wins without scalar baseline and reproducible input.

Prefer measured, reversible changes with documented evidence.
