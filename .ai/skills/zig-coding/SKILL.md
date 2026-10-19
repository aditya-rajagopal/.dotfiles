---
name: zig-coding
description: Use when implementing, debugging, reviewing, or optimizing Zig code and build.zig integration, with strict TigerStyle safety and performance standards.
---

# Zig Coding

Write robust, high-performance Zig. Prioritize **safety, performance, then developer experience**. The default is **TigerStyle-critical**; a small task does not silently select a weaker profile. Scale investigation to the change, while preserving the engineering standard.

## Establish the target

Use the repository's pinned compiler and build conventions. Compare that pin with `zig version`/`zig env` when compilation or API compatibility matters. A different compiler on `PATH` is not the target. Resolve unfamiliar or changing APIs from the matching stdlib source; do not migrate the project to make a remembered snippet work.

## Engineering contract

- **Design for performance early.** Account for workload, algorithmic complexity, bytes moved, allocation frequency, and I/O. Prefer bounded storage, contiguous access, and batching where they fit the workload. Measure changes to established hot paths and support optimization claims with before/after evidence.
- **Plan memory before steady state.** Default to preallocated capacity and no allocation, freeing, or growth after initialization. Make allocation phases, ownership, lifetimes, and capacity exhaustion visible. An allocator parameter alone does not justify runtime allocation.
- **Stream sequential transformations.** Prefer bounded streaming over full-file intermediates; make buffer lifetimes and memory budgets explicit.
- **Bound work and validate boundaries.** Use nonrecursive runtime control flow and explicit limits on externally driven work, queues, retries, and input sizes. Handle malformed input and resource exhaustion with runtime checks and errors. Assert internal preconditions, postconditions, and cross-field invariants; pair critical checks across producer/consumer boundaries.
- **Protect state transitions.** State the failure guarantee. Complete fallible preparation before committing mutations that must be atomic; account for aliasing and pointer invalidation during growth. Clean up owned resources on every exit.
- **Keep mechanisms concrete.** Prefer direct fields and concrete parameter types. Accessors that enforce invariants or meaningful semantics, and generics with real type variation, are justified uses. Preserve existing public APIs within the requested scope.
- **Make control flow explicit.** Split compound conditions into simple nested `if`/`else` branches, even for pure predicates; express complex `else if` chains as explicit trees. Preserve evaluation order and short-circuit behavior. Bind meaningful intermediate results to named `const`s instead of nesting or chaining multiline calls. Separate state queries, decisions, mutations, and failure checks.

## Exceptions require alignment

A necessary OS/API constraint or a demonstrated subsystem requirement may justify a deviation. First describe the exact rule, necessity, alternatives, and safety/performance cost; isolate the deviation behind a narrow boundary where possible. Existing **explicit user or applicable repository approval** counts. Mere existing usage does not. If approval is absent, prepare the concrete proposal and obtain user agreement before adopting the exception; continue unaffected work. Keep the approved rationale near the boundary. Do not ask again for the same approved scope.

## Read only what the task needs

| Decision | Reference |
|---|---|
| Compiler mismatch, stdlib API, build imports, test commands | [toolchain.md](references/toolchain.md) |
| Contracts, arithmetic, parser bounds, critical review | [safety.md](references/safety.md) |
| Allocation phases, ownership, OOM, growable containers | [memory-management.md](references/memory-management.md) |
| File/directory I/O, streaming buffers, atomic replacement | [file-io.md](references/file-io.md) |
| MultiArrayList, handles, ABI/layout | [data-layout.md](references/data-layout.md) |
| Hot paths, concurrency, benchmarks, SIMD, comptime | [performance.md](references/performance.md) |
| Refactoring, abstraction, accessors, generics | [code-evolution.md](references/code-evolution.md) |
| Provenance and example verification scope | [sources.md](references/sources.md) |

Use the relevant row directly; there is no mandatory reference-reading sequence. Resolve paths relative to this skill directory. Run experiments in the task workspace.

## Completion evidence

Use the project's actual build/test graph. Exercise changed boundary behavior and relevant failure paths, then run required repository checks. Report the compiler used, checks and outcomes, approved deviations, and performance evidence when applicable. If the target toolchain or benchmark is unavailable, identify the unverified claim instead of implying success.
