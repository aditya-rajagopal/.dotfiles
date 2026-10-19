# File and directory I/O

Use the repository's compiler and I/O model. Do not translate legacy `std.fs` code to `std.Io` as an incidental cleanup. The example below is for the specific `std.Io` toolchain recorded in [sources.md](sources.md), not every version with an `Io` namespace.

## I/O context and resource ownership

The application selects the I/O implementation. Reusable code receives `io: std.Io` on toolchains using that model; it does not select `std.Io.Threaded.global_single_threaded` internally. Thread/cancellation behavior and backend allocations belong in the application resource plan. Necessary OS/backend exceptions follow the same explicit alignment rule as other deviations.

Borrowed handles remain owned by the caller. Close handles opened by the function on all exits. `std.Io.Dir.cwd()` is a borrowed special handle: do not close it or iterate it directly. Open a directory with iteration capability, then close that owned handle.

## Example: bounded directory counting

This counts immediate entries in an opened directory. The limit is caller policy, enforced by a runtime error. It does not recurse, allocate application storage, or close the borrowed parent. Backend resource behavior still depends on the chosen `Io` implementation.

```zig
const std = @import("std");

pub fn countEntries(
    io: std.Io,
    parent: std.Io.Dir,
    sub_path: []const u8,
    max_entries: usize,
) !usize {
    var dir = try parent.openDir(io, sub_path, .{ .iterate = true });
    defer dir.close(io);
    var it = dir.iterate();
    var count: usize = 0;
    while (try it.next(io)) |_| {
        if (count == max_entries) return error.EntryLimitExceeded;
        count += 1;
    }
    return count;
}
```

## Reading and writing

- Prefer bounded streaming for sequential transformations. Whole-file reads need an algorithmic or small-input justification and an enforced byte limit.
- State who owns each buffer, how long borrowed views remain valid, and when storage may be reused. Queuing a slice does not extend its lifetime.
- Budget all in-flight storage across active jobs, including retained history, partial records, queues, scratch, and output. Bound queue bytes as well as item counts; propagate backpressure upstream.
- `stat.size` is a hint, not a stable content contract. A file can change; a stream may not provide a size. Enforce the application byte limit while consuming data and handle short reads/EOF explicitly.
- Check partial progress and error semantics of the exact reader/writer API. Complete buffered writes with the operation its contract requires (`flush`, `end`, or another version-specific method); success from a buffer-only write is not proof of delivery.
- Directory entry names may borrow iterator storage. Copy only when necessary and authorized, or consume them before advancing. Directory order is not a stable protocol.
- When security depends on path or file type, a prior `stat` check is not sufficient against replacement races. Use the repository's handle-relative/open-time protections for that threat model.

## Atomic visibility and durability

For replacement, inspect the target's atomic-file helper, replacement options, cleanup, and filesystem constraints. Readers observing either the old or new name/content is an atomic visibility property. Crash durability additionally depends on file data/metadata synchronization, directory synchronization, filesystem, and platform guarantees. Do not claim durable storage from a rename or buffer flush alone. Preserve the application's established persistence protocol; introducing one requires explicit requirements.
