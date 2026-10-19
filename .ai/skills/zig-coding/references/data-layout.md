# Layout, identity, and data movement

## Choose layout from the workload

Count the bytes and fields traversed by the dominant operations. SoA/MultiArrayList can help field-selective iteration; AoS can fit operations that consume whole records. Compare realistic workloads before claiming a win. Contiguous access, fewer allocations, and avoiding unnecessary indirection matter more than mechanically selecting one container.

For `std.MultiArrayList`, inspect the target's `items(.field)`, `slice()`, reserve, resize, and removal contracts. Reserve during initialization. Cache field slices for a bounded loop only while operations cannot relocate storage or invalidate the view. Reacquire views after structural mutation. Distinct field arrays are not a serialized row representation.

## Layout guarantees

- An ordinary `struct` has compiler-determined layout. Declaration order is not a portable padding-control technique, ABI, or wire format.
- `extern struct` follows the target C ABI. Field ordering and padding must match that ABI and any external declaration; do not reorder for aesthetics.
- `packed struct` provides bit-layout semantics and specialized pointer/alignment behavior. It is not a general “faster and smaller” switch.

Use `@sizeOf`, `@alignOf`, and appropriate field-offset queries when layout assumptions matter. Check relevant targets, not just the host. Use explicit serialization and byte-order conversion for portable formats; dumping ordinary struct bytes can expose padding and produce unstable data.

## Handles and borrowed pointers

Pointers and slices into growable containers can become invalid on growth. Even without growth, remove/swap/compact operations can change which object occupies an address or index.

An integer index is a stable handle only while the container's mutation policy preserves that identity. If slots are reused, use generation-checked handles or another explicit lifetime scheme when stale references are possible. Check index bounds and generation before access; handle generation wrap according to the subsystem's lifetime policy. Fixed capacity prevents reallocation, not every identity bug.

For concurrency, distinguish false sharing, actual data races, and intentional sharing. Alignment or padding can mitigate false sharing but cannot make racy access correct. Measure on deployment-relevant hardware, accounting for added memory footprint.
