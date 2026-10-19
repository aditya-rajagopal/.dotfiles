# Memory phases, ownership, and mutation

## Design allocation phases

Default to allocating capacity at initialization and reusing bounded storage in steady state. Size capacity from the workload and memory budget. At exhaustion, return an error, apply backpressure, or use the documented admission policy; do not silently grow the container.

Distinguish startup/setup, request admission, and hot-loop execution. Calling an allocation “initialization” inside every request does not make repeated runtime allocation comply with the default. A necessary dynamic subsystem is an exception: identify its budget, frequency, latency impact, ownership, and isolation boundary, then use the existing approval or obtain alignment as described in `SKILL.md`.

Fixed arrays, fixed-buffer allocators, and pools can make consumption predictable, but account for stack size, alignment, maximum live objects, and exhaustion. An arena backed by a general allocator can still grow. A memory pool is not bounded merely because it reuses objects.

## Ownership is part of the API

For allocation-capable initialization or an approved dynamic boundary, make the allocator explicit or visibly stored in the owning object. Document who owns the result, which allocator releases it, and which borrows become invalid. Passing an allocator does not establish whether allocation is allowed in that phase.

Use `defer` for owned-resource cleanup and `errdefer` for partially constructed values. An allocation you own may be freed through a caller-supplied allocator; ownership of the allocator object is not required. Free with the matching allocator and original allocation shape required by its contract. Avoid copying owning structs into two values that both deinitialize the same resource.

Arena-backed slices die at reset/deinit. Copying a result to its longer-lived owner is one option when that allocation is authorized. Another is caller-provided output storage. Never return a borrowed scratch slice as an owned result.

## Failure atomicity and aliasing

First choose the guarantee: unchanged logical state on error, valid but partially updated state, or another explicit contract. Reserve-first is useful in initialization and approved dynamic paths when growth is the only fallible preparation. It does not make later parsing, callbacks, I/O, or validation infallible.

Growth can relocate storage before a mutation loop starts. If input aliases the container being grown, preserve its identity with indices and reacquire the slice after growth, use already reserved storage, or stage it in authorized scratch space. Do not unconditionally add a heap snapshot to a no-allocation path. Document non-aliasing only when callers can satisfy that contract; do not silently break existing aliasing support.

## Example: append within preallocated capacity

This helper accepts the live list's own items as input. It never grows storage; the source and appended destination are disjoint when `items` is within the live prefix. Other overlapping spans into unused capacity are outside its contract. On capacity failure, length and contents are unchanged.

```zig
const std = @import("std");

pub fn appendBounded(
    list: *std.ArrayList(u32),
    items: []const u32,
) error{CapacityExceeded}!void {
    std.debug.assert(list.items.len <= list.capacity);
    if (items.len > list.capacity - list.items.len)
        return error.CapacityExceeded;
    for (items) |item| list.appendAssumeCapacity(item);
}
```

The caller initializes/reserves the list before steady state and owns deinitialization. Confirm container signatures in the target stdlib; the example's tested toolchain is recorded in [sources.md](sources.md).

## Verification

Check exact capacity and one beyond it, aliasing with and without growth where growth is permitted, and borrow invalidation. A no-allocation contract should be tested with a failing/counting allocator or a setup that cannot grow. For fallible constructors and approved dynamic paths, use the target version's leak detector and allocation-failure tools to exercise each failure point. Debug/testing allocator names and APIs vary by compiler version; inspect the matching source.
