# TigerStyle-critical safety

The strict default applies to ordinary Zig work too. Deviations follow the alignment rule in `SKILL.md`; apparent convenience is not justification. Apply these requirements to the code being changed without expanding the task into a repository-wide rewrite.

## Contracts and failure modes

Make preconditions, postconditions, state transitions, and capacity/lifetime assumptions explicit. Assert meaningful programmer invariants near the operations that depend on them. For high-value properties, check both the producing and consuming boundaries, using independently derived facts where possible. Prefer compile-time checks for relationships between constants and layouts.

Assertions must be side-effect free. Split independent assertions when doing so improves failure diagnosis. Check valid and invalid state combinations, including states that must never occur. A tautology or an assertion that simply repeats a type guarantee is not a substitute for a useful contract.

Zig's `std.debug.assert` is not always-on validation: failure is illegal behavior, and checks can disappear in `ReleaseFast`/`ReleaseSmall`. Untrusted lengths, headers, indices, OS results, and exhaustion therefore need runtime validation before internal invariant assertions. If production must always detect an internal corruption condition, choose the repository's explicit always-on failure mechanism and account for its cost.

An internal, already validated header can have a magic-value invariant. Bytes just read from a file or network must first be validated, even if a paired assertion exists on the writer. Handle recoverable errors; do not discard them or convert them into `unreachable` to simplify the type.

## Bounds and arithmetic

- Give each finite loop a termination argument and each input-driven operation a resource limit. Derive limits from a contract or capacity; do not invent a constant as a ritual.
- Keep runtime control flow nonrecursive by default. An explicit traversal stack still needs a capacity/depth policy.
- An intentional service/event loop has an explicit lifecycle, shutdown/cancellation behavior, and bounded work per iteration. A fixed total iteration limit would change its purpose.
- Check queue, retry, parser, and allocation budgets with errors or backpressure. Assertions cannot enforce a limit driven by external load.
- Use fixed-width types for persisted formats, protocols, domain quantities, and intentional bounds. Use `usize` where Zig indexing/allocation APIs require native sizes, with checked conversion at domain boundaries.
- Validate arithmetic before it can overflow: for a slice length, establish `start <= buf.len` and `len <= buf.len - start` before computing `start + len`. A check after overflowing multiplication is too late. Use checked arithmetic when a capacity calculation can overflow; use wrapping arithmetic only when the algorithm requires it.
- Treat `@intCast`, `@alignCast`, pointer casts, and unchecked access as proof obligations. A type assertion or debug-only check cannot replace validation of attacker-controlled values.

## Example: bounded parsing without allocation

This example uses subtraction to make the length check safe. `start` and `len` may be untrusted. The returned slice borrows `buf`.

```zig
pub fn checkedWindow(
    buf: []const u8,
    start: usize,
    len: usize,
) error{InvalidRange}![]const u8 {
    if (start > buf.len) return error.InvalidRange;
    if (len > buf.len - start) return error.InvalidRange;
    return buf[start..][0..len];
}
```

## Verification by failure mode

Test the changed contract: zero, exact capacity, one beyond capacity, truncated/malformed input, overflow, and invalid state transitions as relevant. Exercise cleanup and allocation failures when ownership or fallible initialization changes. Fuzzing or deterministic simulation is valuable for parsers/state machines when the risk warrants it; it is not a substitute for understanding invariants.

Use safety-enabled builds to expose illegal behavior and the deployment build mode to check behavior that must not depend on debug assertions. For critical state transitions, verify the promised state after failure, not just the returned error. During review, trace input validation, arithmetic, lifetime, and mutation order together.
