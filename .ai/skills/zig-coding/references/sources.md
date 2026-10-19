# Sources and verification scope

## Authority for a coding task

Use the user's explicit requirements, applicable repository instructions, and its exact compiler/build graph. This skill supplies strict defaults; it does not silently override an explicitly approved local exception. Inspect the target compiler's bundled language reference and stdlib for API contracts. The skill's examples are not a compatibility promise for every release.

## Zig examples

Last compiled verification of the self-contained examples in `safety.md`, `memory-management.md`, and `file-io.md`:

- Date: 2026-10-18.
- Compiler: `0.18.0-dev.1+a6c6412a8`.
- Host target: macOS aarch64.

This records one development snapshot, not the latest stable release or a minimum supported version. Recheck examples against the task's pin. The historical 0.16-dev verification statement has been replaced; no cross-version or cross-platform test coverage is implied.

Primary references:

- [Zig documentation index](https://ziglang.org/documentation/) — select the matching release, or use the compiler's bundled reference.
- Matching local sources: `std.zig`, `array_list.zig`, `multi_array_list.zig`, `debug.zig`, `testing.zig`, allocator implementations, `Io/Dir.zig`, `Io/Threaded.zig`, and `Io.zig` as relevant.
- [TigerStyle](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md) — safety/performance priorities, bounded execution, contracts, and allocation discipline. This skill applies the user's strict default and explicit exception policy; it does not import TigerBeetle's entire repository workflow.
- [It takes two to contract](https://tigerbeetle.com/blog/2023-12-27-it-takes-two-to-contract) — paired invariant checks.
- [Semantic Compression](https://caseymuratori.com/blog_0015) and [Complexity and Granularity](https://caseymuratori.com/blog_0016) — concrete code and useful abstraction boundaries.

## Skill authoring basis

Reviewed 2026-10-18:

- [OpenAI: Rethinking skills and prompts](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra) — concise discovery, selective reference loading, and avoiding redundant process.
- [OpenAI: Testing Agent Skills Systematically with Evals](https://developers.openai.com/blog/eval-skills) — observable task outcomes and invocation controls.
- [Anthropic: Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) — relevant context, progressive disclosure, and realistic evaluation.
- [Agent Skills specification](https://agentskills.io/specification) — portable skill structure.

Skill-creator and Superpowers' writing-skills workflow were used during authoring and validation. They are not runtime dependencies of this skill. Syntax/link validation and a few agent scenarios are limited evidence, not proof of reliability across models or tasks.
