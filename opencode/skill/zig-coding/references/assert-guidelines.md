# Assert Guidelines

Use assertions to detect programmer mistakes and invariant violations.
Use typed errors (`error{...}`) for expected runtime failures.

## Good Assert Targets

- Internal invariants (state machine shape, buffer geometry, index relationships).
- Preconditions for internal helpers where callers are controlled.
- Postconditions after mutation where corruption would be catastrophic.
- Bounds checks immediately before unchecked indexing/casts/bit tricks.
- Cross-field consistency (`width * height == cells.len`, checksum linkage, etc.).

```zig
assert(index < items.len);
assert(self.width * self.height == self.cells.len);
assert(header.magic == expected_magic);
```

## Bad Assert Targets

- External malformed input (user data, network payloads, file format from untrusted source).
- Recoverable runtime failures (I/O, temporary lock failure, allocation pressure).
- Cleanup best-effort paths (`deinit`, shutdown restore paths).

```zig
// Bad: external input may be malformed.
assert(packet[0] == 0x7f);

// Bad: runtime failures should be handled.
assert(writer.interface.writeAll(bytes) == void{});
```

## Pair Assertions (Important)

For high-value properties, assert in at least two places:

- **Producer side**: before writing/sending/committing.
- **Consumer side**: after reading/receiving/loading.

This follows TigerBeetle's "pair assertions" practice and catches divergence across boundaries.

## Practical Rules

- Keep assert expressions side-effect free.
- Prefer split asserts for precision: `assert(a); assert(b);`.
- Assert both positive and negative space where useful.
- Keep hot-path asserts cheap; push expensive checks to boundaries.
- Add tests for invalid paths; asserts are not test replacements.
