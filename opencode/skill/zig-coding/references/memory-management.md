# Memory Management Patterns

This file focuses on allocator-explicit Zig code that remains predictable under load.

## Core Rules

- Allocation behavior must be obvious at the call site.
- Prefer explicit allocator parameters in reusable code.
- Separate fallible allocation from infallible mutation.
- Prefer bounded/static memory where limits are known.

## Allocator Surface

For reusable functions, expose allocator intent directly:

```zig
const std = @import("std");

fn parseBlob(gpa: std.mem.Allocator, input: []const u8) ![]u8 {
    const out = try gpa.alloc(u8, input.len);
    @memcpy(out, input);
    return out;
}
```

If a function does not allocate, avoid accepting allocator parameters unless needed for symmetry.

## Reserve-First Pattern

Keep all failure before mutation in append-heavy paths:

```zig
fn appendSlice(
    gpa: std.mem.Allocator,
    list: *std.ArrayList(u32),
    items: []const u32,
) !void {
    try list.ensureUnusedCapacity(gpa, items.len); // fallible
    for (items) |item| list.appendAssumeCapacity(item); // infallible
}
```

This avoids partially-mutated state when allocation fails.

## Arena Pattern

Use `ArenaAllocator` for request/frame scratch lifetime:

```zig
fn processFrame(
    gpa: std.mem.Allocator,
    scratch_backing: std.mem.Allocator,
    input: []const u8,
) ![]u8 {
    var arena = std.heap.ArenaAllocator.init(scratch_backing);
    defer arena.deinit();
    const temp = arena.allocator();

    const parsed = try parseBlob(temp, input);
    return try gpa.dupe(u8, parsed);
}
```

For loops, consider `arena.reset(.retain_capacity)` when reuse is appropriate.

## Static and Bounded Memory

Use fixed arrays or fixed-buffer allocators when bounds are known:

```zig
var backing: [64 * 1024]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&backing);
const alloc = fba.allocator();
```

Benefits: predictable latency, no syscall churn, easier worst-case reasoning.

## Choosing an Allocator

- `std.heap.DebugAllocator` for development/debugging memory bugs.
- `std.testing.allocator` in tests to catch leaks.
- `std.heap.ArenaAllocator` for scoped temporary lifetimes.
- `std.heap.FixedBufferAllocator` for bounded/no-syscall paths.
- `std.heap.MemoryPool(T)` for many same-type objects.

## Error and Cleanup Discipline

- Use `errdefer` for partial-construction cleanup.
- Keep ownership transfer explicit in return values and names.
- Do not free memory from allocators you do not own.

```zig
fn makeThing(gpa: std.mem.Allocator) !*Thing {
    const t = try gpa.create(Thing);
    errdefer gpa.destroy(t);
    t.* = .{};
    return t;
}
```

## Review Checklist

- Allocator source and lifetime are obvious.
- No hidden global/page allocator usage in library paths.
- Reserve-first applied before inner-loop mutation.
- `defer`/`errdefer` paths are paired and complete.
- Tests cover OOM or allocation-failure behavior where practical.
