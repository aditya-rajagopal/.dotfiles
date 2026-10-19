# Concrete APIs and justified abstraction

Write for the current domain and preserve the host repository's public contracts. Factor code when shared behavior or an invariant is established and centralizing it reduces mistakes. Repeated shape is evidence, not a required count of three; duplication that causes inconsistent fixes is also evidence.

Prefer concrete parameter types so ownership, representation, and accepted inputs are visible. Use `anytype` or a comptime type parameter for real type variation, such as an established writer interface or numeric implementation. State the required operations and verify the types actually supported. Do not turn one concrete use into a generic framework in anticipation of hypothetical callers.

Prefer direct struct fields for plain data. A trivial getter/setter that adds no semantics is usually unnecessary. An accessor can be justified by invariant enforcement, a computed value, synchronization, or a meaningful abstraction boundary. Existing public accessors need not be removed to enforce this preference; removal is a compatibility decision within the user's task.

Use names that describe the domain operation. Follow local naming conventions; examples from an essay do not establish Zig-wide casing rules. Keep functions and scopes small enough to audit without fragmenting one invariant across many helpers.

Higher-level helpers should retain the lower-level control their actual callers need. Do not preserve every unused internal escape hatch forever, or break a supported lower-level API incidentally. Distinguish public compatibility from internal implementation cleanup.

During refactoring, preserve error behavior, ownership, aliasing, resource bounds, and measurable performance characteristics. A shorter diff or fewer lines does not prove a better abstraction. Tests should protect observable contracts and relevant failure states, not mirror the new helper structure.
