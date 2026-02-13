# Performance-Aware Zig

Use performance awareness continuously, not only during late "optimization" passes.

## Design-Time Priorities

From performance-aware programming practice:

- Avoid obvious waste first.
- Reason about data movement before micro-tuning instructions.
- Model bottlenecks across memory, CPU, disk, and network.

## Workflow

1. Establish correctness with simple scalar code.
2. Measure in realistic build mode and input size.
3. Identify dominant bottleneck (not assumed bottleneck).
4. Apply targeted change (layout, algorithm, SIMD, batching).
5. Re-measure and keep only proven wins.

## Measurement Basics

```zig
const std = @import("std");

fn bench(comptime f: anytype, arg: anytype, iterations: usize) !u64 {
    var timer = try std.time.Timer.start();
    var i: usize = 0;
    while (i < iterations) : (i += 1) {
        _ = @call(.never_inline, f, .{arg});
    }
    return timer.read() / iterations;
}
```

Use `std.mem.doNotOptimizeAway` for values/results that could be optimized out.

## Hot Path Heuristics

- Prefer contiguous memory and linear scans.
- Batch work to reduce overhead and branch unpredictability.
- Hoist invariant computation out of loops.
- Keep hot loops simple and explicit.

Only use branchless tricks when measured benefit is real.

## SIMD and Comptime

- SIMD (`@Vector`) is for measured hot loops with suitable data shape.
- Start scalar, then vectorize.
- Keep scalar remainder path for tails.
- Use comptime lookup tables and compile-time validation where it removes runtime work safely.

```zig
const Vec8 = @Vector(8, f32);
const scale: Vec8 = @splat(2.0);
```

## Data Layout and Throughput

- MultiArrayList/SoA often helps field-selective loops.
- Beware false sharing in multithreaded counters.
- Align data when architecture/vector width justifies it.

## Build and Test Mode

- Profile in release modes that match deployment (`ReleaseFast`/`ReleaseSafe`).
- Do not conclude from Debug timing.
- Keep benchmark input deterministic and documented.

## Review Checklist

- Claim is backed by before/after measurement.
- Bottleneck source is identified, not guessed.
- Change does not hide allocations or regress safety invariants.
- Complexity added is proportional to measured gain.
