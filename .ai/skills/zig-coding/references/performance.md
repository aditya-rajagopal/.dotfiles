# Performance from design through measurement

## Reason before implementing

For the changed path, estimate workload sizes, work per item, peak memory, bytes copied, allocations, I/O calls, and the required latency/throughput. Account for frequency as well as individual operation cost. These estimates guide architecture before a benchmark exists; “measure first” is not permission to ignore an obviously poor algorithm or unbounded memory growth.

Separate control/setup work from the data path. Preallocate capacities, reuse scratch storage, batch operations, and arrange hot data for the accesses that dominate. Check worst-case and tail behavior: amortized container growth can still violate a latency budget. Necessary exceptions remain explicit and isolated.

## Concurrency and batching

Start with synchronous streaming; a logical stage need not be a thread. Compare parallelism across independent jobs with selective overlap within one job. Add concurrency only when end-to-end latency and throughput measurements justify it. Measure first useful output, validated completion, and relevant tail latency under representative single-job and concurrent loads, including scheduling, synchronization, copying, and memory costs. Share bounded worker and buffer budgets across jobs.

Choose I/O buffers and processing batches from the actual working set and target measurements. A page-sized buffer does not guarantee L1 residency; include algorithm state, other active buffers, and cross-core transfers.

## When measurement is required

Measure before and after changing an established hot path or making an optimization claim. Keep correctness checks and the workload equivalent. For other changes, allocation and complexity analysis is appropriate unless evidence reveals a performance-sensitive effect.

Use the repository's benchmark harness where available. Record:

- Compiler version, target/CPU, build mode, and relevant options.
- Input size/distribution and workload seed or fixture.
- Before/after timing or throughput, sample count and variability.
- Allocation count/peak memory, I/O, or tail latency when those are the constraint.

Run repeated comparable samples and account for warmup, background load, caching, and measurement overhead. Debug timing is not deployment performance. Use the actual deployment mode; `ReleaseFast` and `ReleaseSafe` can have different behavior. If there is no baseline, state that a comparison is not established. If measurements are unavailable, label the expected benefit as an estimate.

## Benchmark correctness

Consume results so the compiler cannot discard the work. Inspect whether constant folding or loop-invariant hoisting invalidates the experiment; a non-inlined call alone does not prevent optimization. Use runtime inputs and the target version's `std.mem.doNotOptimizeAway` where appropriate, and inspect generated code when results are suspicious. Exclude setup only when that matches the question; also measure end-to-end impact when moving costs between phases.

Use the matching toolchain's monotonic clock or harness. Do not copy a universal `std.time.Timer` recipe: clock APIs vary across Zig versions. Reject zero iterations, handle unsupported/low-resolution clocks, and keep timing/reporting overhead outside the workload. A short timing sample below clock resolution cannot support a speedup claim.

## SIMD and comptime

Keep a correct scalar baseline. Use `@Vector` when data dependencies and access shape support it; test tails, small inputs, alignment, and nonfinite/overflow cases where relevant. Check floating-point semantics and permitted numerical changes. Do not assume vector syntax produces a faster instruction sequence on every target.

Use comptime to specialize real variation and verify constant relationships. Consider compile-time cost, generated code size, instruction-cache pressure, and target support. Avoid a generic framework or branchless rewrite whose complexity exceeds its demonstrated benefit.

For a performance change, deliver reproducible commands and results alongside the changed code. Keep only improvements that satisfy the safety contract and the relevant workload, or clearly explain a deliberate tradeoff already aligned with the user.
