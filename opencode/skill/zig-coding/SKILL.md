---
name: zig-coding
description: Write correct, high-performance Zig with explicit memory, version-aware stdlib usage, and TigerStyle-inspired safety rules. Use when implementing, refactoring, reviewing, debugging, or optimizing Zig code (build.zig, allocators, MultiArrayList, comptime, SIMD, std APIs).
references:
  - references/README.md
  - references/workflow.md
  - references/compatibility.md
  - references/memory-management.md
  - references/data-layout.md
  - references/tigerstyle-safety.md
  - references/code-evolution.md
  - references/performance.md
  - references/file-io.md
  - references/zig-environment.md
  - references/anti-patterns.md
  - references/review-gate.md
---

# Zig Coding

Use this skill when writing or reviewing Zig code that must be safe, explicit, and fast.

## Defaults

- Prioritize decisions in this order: `safety -> performance -> developer experience`.
- Treat allocation behavior as API surface. Hidden allocation is a bug unless clearly documented.
- Prefer concrete code first; abstract only after repeated, proven duplication.
- Be version-aware. Zig stdlib APIs move quickly.

## Fast Workflow

1. **Identify version and build model**
   - Run `zig env` and note `.version`, `.std_dir`, `.global_cache_dir`.
   - Read `build.zig` and `build.zig.zon` before assuming module/API shape.
2. **Pick strictness profile**
   - Start with `baseline`.
   - Escalate to `strict` or `tigerstyle-critical` for storage/protocol/hot-path correctness.
3. **Implement with explicit contracts**
   - Allocator ownership, bounds, invariants, and error handling should be visible in signatures.
4. **Verify progressively**
   - Focused test first (`--test-filter`), then package/full build tests.
5. **Document why**
   - Capture perf assumptions and safety invariants in code/tests.

## Task Router

What are you doing?

```text
Need coding policy and entrypoint?
├─ Start at references/README.md
├─ Need execution plan? -> references/workflow.md
├─ Need version/API mapping? -> references/compatibility.md
├─ Allocators/arenas/ArrayList? -> references/memory-management.md
├─ MultiArrayList/SoA/layout? -> references/data-layout.md
├─ Assertions/negative space/loop bounds? -> references/tigerstyle-safety.md
├─ Compression-oriented refactors? -> references/code-evolution.md
├─ Profiling/SIMD/comptime tradeoffs? -> references/performance.md
├─ std.Io / file-system operations? -> references/file-io.md
├─ stdlib/module discovery in repo? -> references/zig-environment.md
├─ Need pitfall scan? -> references/anti-patterns.md
└─ Pre-merge gate? -> references/review-gate.md
```

## Reading Order

| Task | Files |
|------|-------|
| New Zig task in unknown repo | `references/README.md` -> `references/workflow.md` -> `references/compatibility.md` |
| Add feature in existing module | `references/workflow.md` -> topic file (`memory-management.md`, `data-layout.md`, etc.) |
| Fix crash/data corruption risk | `references/tigerstyle-safety.md` -> `references/assert-guidelines.md` |
| Optimize hot path | `references/performance.md` -> `references/data-layout.md` |
| Update file/build integration | `references/file-io.md` -> `references/zig-environment.md` |
| Final quality pass before merge | `references/anti-patterns.md` -> `references/review-gate.md` |

## Non-Negotiables

- **Allocator explicitness**: allocation-capable functions must make allocator behavior obvious.
- **Reserve-first mutations**: separate fallible capacity growth from infallible append/set loops.
- **Bounded behavior**: loops need clear termination; unbounded work needs explicit guardrails.
- **Error discipline**: expected runtime failure returns typed errors; assertions are for programmer invariants.
- **No premature abstraction**: write concrete first, then compress repeated shape.
- **Version checks first**: do not cargo-cult std APIs across Zig versions.

## Profiles

| Profile | Use When | Expectations |
|---------|----------|--------------|
| `baseline` | Most app/library code | Clear errors, explicit allocators, sensible tests |
| `strict` | Stateful subsystems, parsers, infra glue | Stronger invariants, paired assertions on boundaries |
| `tigerstyle-critical` | Protocol, storage, money/data correctness, deterministic simulation | Aggressive contracts, bounded loops, stronger review gates |

`tigerstyle-critical` is inspired by TigerBeetle's `TIGER_STYLE.md`, adapted for the host repo's constraints (it is not a mandate to mirror TigerBeetle everywhere).

## Verification Commands

- Primary: `zig build test`
- Focused: `zig test path/to/file.zig --test-filter "name"`
- Build graph checks: `zig build -freference-trace`
- Environment sanity: `zig env`

When changing perf-sensitive code, include measurement notes (benchmark input, build mode, before/after).

## In This Reference

| File | Purpose |
|------|---------|
| `references/README.md` | Entry index and task routing |
| `references/workflow.md` | Day-to-day agent workflow and checklists |
| `references/compatibility.md` | Zig-version/API compatibility map |
| `references/memory-management.md` | Allocator and lifetime patterns |
| `references/data-layout.md` | SoA/MultiArrayList/layout guidance |
| `references/tigerstyle-safety.md` | Safety contracts, bounds, assertion strategy |
| `references/assert-guidelines.md` | Practical assert do/don't rules |
| `references/code-evolution.md` | Compression-oriented code evolution |
| `references/performance.md` | Performance-aware design and measurement |
| `references/file-io.md` | Correct stdlib I/O patterns for modern Zig |
| `references/zig-environment.md` | Discover stdlib/modules/dependencies in a repo |
| `references/anti-patterns.md` | Common mistakes and safer alternatives |
| `references/review-gate.md` | Final pre-merge quality and risk checks |
| `references/sources.md` | External sources and verification basis |
