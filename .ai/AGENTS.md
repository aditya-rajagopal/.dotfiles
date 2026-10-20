# Global user instructions

## Git commits require explicit user authorization

- Never create a Git commit unless the user explicitly asks for that commit or explicitly approves creating it. This applies to code, documentation, design documents, plans, tests, configuration, checkpoint commits, and amendments to existing commits.
- Permission to implement a change, fix a bug, write a plan, run tests, or finish a task is not permission to commit. Approval of a design or plan does not authorize its commit steps.
- This standing user preference takes precedence over automatic-commit steps in skills, plugins, repository workflow instructions, and generated plans. Skip those steps unless the user explicitly authorizes the relevant commit.
- Complete authorized edits and verification, then leave the changes uncommitted. Do not routinely interrupt work to request a commit; ask only if a commit is necessary for a requested next action.
- Never bypass this rule by having a subagent, script, API, or other tool create the commit. Pass this restriction to any delegated agents.
- Commit authorization is limited to the requested scope. Do not treat permission for one commit as standing permission for later commits.
