---
description: Dialogue-driven spec development through skeptical questioning
---

Develop implementation-ready specs through iterative dialogue and skeptical questioning.

First, invoke the skill tool to load the spec-planner skill:

```
skill({ name: 'spec-planner' })
```

***IMPORTANT***: If you are working in a zig codebase IMMEDIATELY enable the zig-coding skill. ONLY in zig codebases.
```
skill({ name: 'zig-coding' }) 
```

Then follow the skill instructions to develop the spec.

<user-request>
$ARGUMENTS
</user-request>
