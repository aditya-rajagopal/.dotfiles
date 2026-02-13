# File I/O Patterns (Modern Zig)

This file targets modern Zig stdlib where `std.Io` is first-class.

## Version Note

Many repos still use `std.fs`-style APIs. Always check project version first (`zig env`, `build.zig`).
See `compatibility.md`.

## Minimal `std.Io` Setup

```zig
const std = @import("std");

const io = std.Io.Threaded.global_single_threaded.io();
const cwd = std.Io.Dir.cwd();
```

## Open and Read

```zig
fn readFileAlloc(gpa: std.mem.Allocator, path: []const u8) ![]u8 {
    const io = std.Io.Threaded.global_single_threaded.io();
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.openFile(io, path, .{ .mode = .read_only });
    defer file.close(io);

    const st = try file.stat(io);
    const len: usize = std.math.cast(usize, st.size) orelse return error.FileTooBig;
    const out = try gpa.alloc(u8, len);
    errdefer gpa.free(out);

    var read_buf: [4096]u8 = undefined;
    var reader = file.reader(io, &read_buf);
    try reader.interface.readSliceAll(out);
    return out;
}
```

## Create and Write

```zig
fn writeFile(path: []const u8, bytes: []const u8) !void {
    const io = std.Io.Threaded.global_single_threaded.io();
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.createFile(io, path, .{ .truncate = true });
    defer file.close(io);

    var write_buf: [4096]u8 = undefined;
    var writer = file.writer(io, &write_buf);
    try writer.interface.writeAll(bytes);
    try writer.flush();
}
```

## Directory Iteration

```zig
fn listDir() !void {
    const io = std.Io.Threaded.global_single_threaded.io();
    const cwd = std.Io.Dir.cwd();
    var it = cwd.iterate();

    while (try it.next(io)) |entry| {
        _ = entry;
    }
}
```

## Atomic Replace Pattern

```zig
fn writeAtomic(path: []const u8, bytes: []const u8) !void {
    const io = std.Io.Threaded.global_single_threaded.io();
    const cwd = std.Io.Dir.cwd();

    var af = try cwd.createFileAtomic(io, path, .{ .replace = true });
    defer af.deinit(io);

    var write_buf: [4096]u8 = undefined;
    var writer = af.file.writer(io, &write_buf);
    try writer.interface.writeAll(bytes);
    try writer.end();
    try af.replace(io);
}
```

## Practical Guidance

- Close file/directory handles promptly with `defer`.
- Use explicit flags (`mode`, `truncate`, `lock`) at call sites.
- Prefer atomic write/replace for config and durable state files.
- Bound directory walks and recursion depth in untrusted paths.
- Use `stat(io)` and `kind` before assuming file type.
