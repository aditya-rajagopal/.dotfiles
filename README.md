# Dotfiles

Run `make` from this repository to build `nob` and install the configuration links. A C compiler and Make are required. `make dry-run` previews the links without changing the destination files.

## Shared AI skills

`.ai/skills` is the source for `zig-coding`, `grill-me`, and `grilling`. Setup links the whole folder into:

- `~/.codex/skills`
- `~/.config/opencode/skills`

Adding or editing a skill in `.ai/skills` makes it available to both tools. Grill Me delegates to Grilling, which requires the question/user-input tool whenever usable. Old OpenCode skill and agent definitions have been removed; `opencode/skills` is a relative compatibility link for existing installations that link the whole OpenCode config directory.

Setup replaces existing skills directories, including their previous contents, with the shared folder. Existing files, directories, and different links are moved to numbered paths under `~/.dotfiles-backups` first. Matching links are left alone. Backups remain outside skill discovery paths. Setup stops with a nonzero exit code on failure; already completed links are retained.

## Windows

Run `make` with a C compiler and Make available, or run `powershell -NoProfile -ExecutionPolicy Bypass -File .\windows.ps1` directly. The script uses its own directory and the current user profile instead of hard-coded drive/user paths. Directory links use junctions; file symlinks require Developer Mode or an elevated shell. Add `-DryRun` to preview.

## Verification

`make test` runs POSIX installation tests in disposable directories. To target another home explicitly, use `make NOB_ARGS='--home "/absolute/test home"'`; Windows PowerShell accepts `-TargetHome 'C:\test home'`. Native Windows installation still needs a Windows smoke test.
