# Data Layout and DoD Patterns

Optimize layout around access patterns, not nouns from the domain model.

## CPU-First Mindset

- Hot loops want contiguous, predictable reads.
- Cache misses dominate many real workloads.
- Separate hot fields from cold fields when access frequencies differ.

## AoS vs SoA

Use Struct-of-Arrays when loops touch only subsets of fields.

```zig
const std = @import("std");

const Entity = struct {
    pos: @Vector(3, f32),
    vel: @Vector(3, f32),
    health: u16,
    flags: u8,
};

var entities = std.MultiArrayList(Entity){};
defer entities.deinit(gpa);

const positions = entities.items(.pos);
const velocities = entities.items(.vel);
for (positions, velocities) |*p, v| p.* += v;
```

## Field Ordering

For plain structs, order fields by alignment/size (largest to smallest) to reduce padding:

```zig
const PacketMeta = struct {
    ptr: *anyopaque,
    ts_ns: u64,
    len: u32,
    kind: u8,
};
```

Always verify with `@sizeOf` and `@alignOf` when layout matters.

## Handles Over Long-Lived Pointers

Pointers into growable containers become invalid after reallocation.
Use integer handles for long-lived references:

```zig
const Handle = u32;

fn getPos(pool: *Pool, h: Handle) *@Vector(3, f32) {
    const idx: usize = @intCast(h);
    return &pool.positions[idx];
}
```

Use pointers only for short-lived local work inside verified bounds.

## MultiArrayList Access Modes

- `items(.field)` for single-field hot loops.
- `slice()` when multiple fields need synchronized indexed access.
- Keep mutation loops narrow and linear.

## Comptime-Driven Layout Helpers

Use compile-time reflection for repetitive structural logic, but avoid over-generalized frameworks.

```zig
fn hasField(comptime T: type, comptime name: []const u8) bool {
    return @hasField(T, name);
}
```

Treat reflection as a tool for reducing proven duplication, not a first step.

## Review Checklist

- Hot loops traverse contiguous memory.
- Long-lived identity uses handles, not raw pointers.
- Struct layout checked where ABI/packing matters.
- SoA used where field-selective iteration dominates.
- Benchmarks validate claimed layout wins.
