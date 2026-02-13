---
name: task-manager
description: Autonomous task planning and orchestration for software engineering tasks using gila. Use when Claude needs to plan work, break down complex tasks, or manage multi-step engineering projects. Automatically creates, tracks, and manages tasks through Kanban-style workflow with dependency handling. Tasks are managed by editing markdown files directly and running gila sync.
---

# Task Manager

Autonomous task planning and orchestration for software engineering using gila.

## When to Use This Skill

Use this skill when:

- User requests help with multi-step engineering tasks
- Claude needs to plan and track work independently
- Projects require breaking down complex features into manageable chunks
- Tasks have dependencies that need coordination
- User mentions "plan", "break down", "orchestrate", or "manage tasks"

Examples:
- "Help me build this feature"
- "Refactor this codebase"
- "Implement this API"
- "Set up CI/CD pipeline"

## Gila Project Setup

Check if gila is initialized:

```bash
which gila  # Verify gila is available
ls -la .gila  # Check if project is initialized
```

If `.gila` directory doesn't exist, initialize:

```bash
gila init
```

## Task Planning Workflow

### 1. Analyze the Goal

Understand the objective and identify:
- Major phases or components
- Independent vs. dependent work
- Critical path tasks
- Expected complexity

### 2. Break Down Tasks

Decompose work into atomic tasks:
- Each task: 1-4 hours of work
- Tasks should be independently verifiable
- Clear acceptance criteria for each task

### 3. Identify Dependencies

Determine task relationships:
- Which tasks must complete before others start
- Which tasks can proceed in parallel
- Critical path for the project

### 4. Assign Metadata

For each task, determine:
- Priority (urgent/high/medium/low)
- Priority value (0-255, higher = more urgent)
- Owner (who will do the work)
- Tags (e.g., backend, frontend, database, testing)

## Task Creation Workflow

### Dependency Graph First

Create a mental or written graph of task dependencies. Create tasks in topological order (tasks with no dependencies first).

### Creating Tasks

Use `gila todo` with appropriate flags:

```bash
gila todo --priority=high --priority-value=200 \
          --owner="claude" \
          --tags="backend,api" \
          --waiting-on="[[task_id_1]],[[task_id_2]]" \
          --blocks="[[task_id_3]],[[task_id_4]]" \
          --description="Detailed description of what needs to be done and acceptance criteria" \
          "Task title"
```

**Important:** Create tasks in dependency order:
1. Tasks with no dependencies (leaves)
2. Tasks that depend on completed tasks
3. Tasks at the top of the dependency graph

### Task Creation Order Example

For a feature requiring: design → backend → frontend → integration → testing:

```bash
# Step 1: Create design (no dependencies)
gila todo --priority=urgent --priority-value=250 \
          --description="Create API design and data models" \
          "Design API"

# Step 2: Create backend (depends on design)
gila todo --priority=high --priority-value=200 \
          --waiting-on="[[design_task_id]]" \
          --description="Implement backend endpoints" \
          "Implement backend"

# Step 3: Create frontend (depends on design)
gila todo --priority=high --priority-value=200 \
          --waiting-on="[[design_task_id]]" \
          --description="Implement frontend UI" \
          "Implement frontend"

# Step 4: Create integration (depends on both)
gila todo --priority=medium --priority-value=150 \
          --waiting-on="[[backend_task_id]],[[frontend_task_id]]" \
          --description="Integrate frontend with backend" \
          "Integration testing"
```

## Task Status Management

### Starting a Task

There is NO `gila update` command. To start a task:

1. Read the task file: `.gila/todo/{taskid}/{taskid}.md`
2. Edit the file to change status: `status: todo` → `status: started`
3. Run `gila sync` to reconcile directory structure
4. Task directory moves to `.gila/started/{taskid}/`

### Completing a Task

1. Run `gila done {taskid}`
2. Task moves to `.gila/done/{taskid}/` with completion timestamp
3. Run `gila sync` to update dependent tasks

### Checking Task Status

```bash
# Find next high-priority tasks
gila find --status=todo --priority=gt:medium

# Check for blocked tasks
gila find --status=waiting

# Review completed work
gila find --status=done

# Find tasks in progress
gila find --status=started
```

## Supplemental Files

Each task directory can contain additional files that stay with the task across status transitions.

### Adding Supplemental Files

Place files in the task directory:
```bash
.gila/todo/{taskid}/
├── {taskid}.md              # Main task file (required)
├── screenshot.png            # Visual evidence
├── error.log                 # Debug information
├── design-notes.md           # Design artifacts
└── code-snippet.py           # Related code
```

### Common Supplemental File Uses

- `screenshot.png` - Visual evidence of bugs or UI issues
- `error.log` - Relevant log output for debugging
- `design-sketch.md` - Design notes or mockups
- `test-results.txt` - Test output
- `code-snippet.*` - Relevant code fragments
- `api-spec.json` - API specifications

### Preservation

Supplemental files are automatically preserved when tasks move between status directories (todo → started → done).

## Task File Editing Guidelines

When manually editing task files:

1. Read the task file first to understand current state
2. Edit YAML frontmatter (between `---` delimiters)
3. Safe to modify:
   - `status` - Change when starting/stopping work
   - `tags` - Add/remove tags as needed
   - Custom extension fields - Add task-specific metadata
4. DO NOT manually modify:
   - `created` - Should remain unchanged
   - `completed` - Let `gila done` handle this
   - `taskid` - Never change this
5. After editing, ALWAYS run `gila sync`

Example edit to start a task:

```markdown
---
title: Implement authentication
status: started  # Changed from todo
priority: high
priority_value: 200
owner: claude
created: 2026-01-13T10:00:00Z
tags:
  - backend
  - security
---
```

Then run: `gila sync`

## Task References

Reference other tasks in descriptions using: `[[taskid]]`

```markdown
This task implements the API endpoint defined in [[blue_falcon_abc]]
```

## Dependency Management

### Using --waiting-on

Blocks a task until dependencies complete:
```bash
gila todo --waiting-on="[[task_a_id]],[[task_b_id]]" "Task C"
```

Task C will be in `waiting` status until tasks A and B are done.

### Using --blocks

Mark downstream tasks:
```bash
gila todo --blocks="[[task_c_id]],[[task_d_id]]" "Task B"
```

Tasks C and D will have task B added to their `waiting_on` lists.

### After Completing Tasks

ALWAYS run `gila sync` after completing a task to:
- Remove completed dependencies from `waiting_on` lists
- Transition waiting tasks to `todo` when all dependencies complete
- Update task directory positions

## Common Workflows

### Feature Implementation

1. Design phase
2. Backend implementation (parallel with frontend)
3. Frontend implementation (parallel with backend)
4. Integration (depends on both)
5. Testing (depends on integration)

Use supplemental files for:
- Design docs in design task directory
- Code snippets in implementation task directories
- Test results in testing task directory

### Bug Fix

1. Reproduction task (add logs/screenshots)
2. Investigation task (depends on reproduction)
3. Fix task (depends on investigation)
4. Verification task (depends on fix)

### Refactoring

1. Analysis task (create refactoring plan)
2. Independent refactoring tasks (no dependencies between them)
3. Integration task (depends on all refactoring tasks)
4. Add before/after code samples to task directories

## Progress Monitoring

Regular monitoring workflow:

```bash
# Check what to work on next
gila find --status=todo --priority=gt:medium

# Check for blockers
gila find --status=waiting

# Review work in progress
gila find --status=started

# Sync after any changes
gila sync
```

## Best Practices

- Always describe tasks clearly in `--description` field with acceptance criteria
- Use tags to organize related work (e.g., backend, frontend, database)
- Run `gila sync` after any manual task file edits
- Run `gila sync` after completing any task to update dependencies
- Use appropriate priority values (0-255) within priority tiers for fine-grained ordering
- Review and update task priorities as context changes
- Add supplemental files to task directories for task-specific artifacts
- Check for waiting tasks regularly after completing work

## Task Granularity Guidelines

- Each task: 1-4 hours of work
- Tasks should be independently verifiable
- Avoid breaking down too finely (overhead) or too coarsely (hard to track)
- Test/verification tasks should be separate from implementation
- Each task should have a clear acceptance criterion

## Error Handling

- If gila command fails, check error message and retry
- If manual file edit fails, check file permissions
- Resolve circular dependencies by removing or reordering tasks
- If `gila sync` reports errors, fix task files and re-run
- Handle failed task completions by manually reverting status changes

## Priority Guidelines

- **Urgent**: Production issues, security bugs, blocking features
- **High**: Important features, critical bugs
- **Medium**: Standard features, improvements
- **Low**: Nice-to-have features, documentation, cleanup

Use priority-value to fine-tune ordering within priority tiers.
