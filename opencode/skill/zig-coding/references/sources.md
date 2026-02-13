# Sources and Verification Basis

This skill was curated from the following sources.

## TigerStyle / TigerBeetle

- TigerBeetle repository style guide: `docs/TIGER_STYLE.md`
  - https://raw.githubusercontent.com/tigerbeetle/tigerbeetle/main/docs/TIGER_STYLE.md
- TigerBeetle blog on pair assertions and contracts:
  - https://tigerbeetle.com/blog/2023-12-27-it-takes-two-to-contract

## Compression-Oriented Programming

- Casey Muratori, "Semantic Compression":
  - https://caseymuratori.com/blog_0015
- Casey Muratori, "Complexity and Granularity":
  - https://caseymuratori.com/blog_0016

## Performance-Aware Programming

- Computer, Enhance! table of contents:
  - https://www.computerenhance.com/p/table-of-contents
- Intro transcript for terminology and framing:
  - https://www.computerenhance.com/p/welcome-to-the-performance-aware

## Zig Stdlib and Environment Verification

Verified against local Zig environment via `zig env`.

Observed environment during review:

- Version: `0.16.0-dev.2261+d6b3dd25a`
- `std_dir`: `/Users/adiraj/tools/zig/lib/std`

Key stdlib files inspected for API correctness:

- `std.zig`
- `array_list.zig`
- `multi_array_list.zig`
- `heap/arena_allocator.zig`
- `Io/Dir.zig`
- `Io/File.zig`
- `Io/Reader.zig`
- `Io/Writer.zig`
- `Io/Threaded.zig`
- `time.zig`
