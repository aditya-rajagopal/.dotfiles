# TigerStyle-Inspired Safety

This guidance is based on TigerBeetle's `docs/TIGER_STYLE.md`
(`https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md`)
and related posts.
Apply proportionally to the criticality of the code.

## Intent

- Prevent silent corruption.
- Detect invalid states early.
- Keep execution and resource use bounded.

Priority order: safety first, then performance, then DX.

## Control Flow Discipline

- Prefer explicit control flow and bounded loops.
- Avoid recursion for input-scaling runtime paths.
- Keep function size and variable scope small enough to audit quickly.

For loops that process external or dynamic queues, enforce explicit limits.

## Assertion Strategy

- Assert preconditions, postconditions, and invariants.
- Use assertions for programmer errors, not expected runtime failures.
- Split compound checks when failure localization matters.
- Assert both positive and negative space when useful.

```zig
assert(index < items.len);
if (state == .stopped) assert(pending_count == 0);
```

## Pair Assertions

For high-value invariants, assert at two boundaries:

- producer and consumer,
- write path and read path,
- encoder and decoder,
- caller and callee postcondition.

This is a practical defense-in-depth pattern from TigerBeetle.

## Bounded Work

- Every loop should have a clear termination argument.
- Long-running/event loops need explicit watchdog or budget checks.
- Queues and buffers should have explicit max capacities.

```zig
const max_iterations = 10_000;
var i: usize = 0;
while (queue.popOrNull()) |item| : (i += 1) {
    assert(i < max_iterations);
    try process(item);
}
```

## Memory Safety Posture

- Prefer stable ownership and lifetimes.
- Minimize allocation churn in critical paths.
- For deterministic subsystems, pre-allocation and bounded pools are preferred.

## Error Handling vs Assertions

- Expected runtime failures: return typed errors.
- Impossible-within-contract failures: assert or `unreachable` with justification.

Do not convert ordinary runtime conditions into assertions.

## Suggested Escalation by Profile

- `baseline`: assert major invariants and bounds.
- `strict`: add paired assertions at module boundaries.
- `tigerstyle-critical`: high assertion density in critical code paths, explicit bounds everywhere, stronger review gates.

## Review Checklist

- Invariants are explicit and test-backed.
- Loops and queues are bounded or budgeted.
- Assertion/error boundary is intentional.
- High-value properties are checked in two independent locations.
