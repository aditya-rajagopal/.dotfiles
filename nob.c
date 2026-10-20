#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"

#ifndef _WIN32
#include <sys/stat.h>
#include <unistd.h>

typedef struct {
    const char *src;
    const char *dst;
    bool directory;
} Transfer_Item;

static const Transfer_Item items[] = {
    {".clang-format", ".clang-format", false},
    {"nvim", ".config/nvim", true},
    {"ghostty", ".config/ghostty", true},
    {".zshrc", ".zshrc", false},
    {".aerospace.toml", ".aerospace.toml", false},
    {".ai/AGENTS.md", ".codex/AGENTS.md", false},
    {".ai/AGENTS.md", ".config/opencode/AGENTS.md", false},
    {".ai/skills", ".codex/skills", true},
    {".ai/skills", ".config/opencode/skills", true},
};

// lstat also detects dangling links, which must be preserved before replacement.
static int path_exists(const char *path) {
    struct stat info;
    if (lstat(path, &info) == 0) return 1;
    if (errno == ENOENT) return 0;
    nob_log(NOB_ERROR, "Cannot inspect %s: %s", path, strerror(errno));
    return -1;
}

static bool ensure_parent(const char *path) {
    Cmd cmd = {0};
    cmd_append(&cmd, "mkdir", "-p", temp_dir_name(path));
    bool ok = cmd_run(&cmd);
    free(cmd.items);
    return ok;
}

static bool install_link(const char *src, const char *dst, const char *backup_base, bool dry_run) {
    struct stat target_info, source_info;
    int exists = path_exists(dst);
    if (exists < 0) return false;
    // A parent link may already expose the source directory at the destination.
    if (exists && stat(dst, &target_info) == 0 && stat(src, &source_info) == 0
        && target_info.st_dev == source_info.st_dev && target_info.st_ino == source_info.st_ino) {
        nob_log(NOB_INFO, "Already linked: %s", dst);
        return true;
    }
    if (dry_run) {
        nob_log(NOB_INFO, "%s%s -> %s", exists ? "Back up and link: " : "Link: ", dst, src);
        return true;
    }
    if (!ensure_parent(dst)) return false;

    const char *backup = NULL;
    if (exists) {
        // Keep backups outside tool discovery directories; never overwrite a prior backup.
        for (unsigned i = 0; i < 1000; ++i) {
            const char *candidate = temp_sprintf("%s.%u", backup_base, i);
            int occupied = path_exists(candidate);
            if (occupied < 0) return false;
            if (!occupied) { backup = candidate; break; }
        }
        if (!backup) {
            nob_log(NOB_ERROR, "No free backup slot for %s", dst);
            return false;
        }
        if (!ensure_parent(backup) || !nob_rename(dst, backup)) return false;
        nob_log(NOB_INFO, "Preserved %s as %s", dst, backup);
    }
    if (symlink(src, dst) != 0) {
        nob_log(NOB_ERROR, "Cannot link %s -> %s: %s", dst, src, strerror(errno));
        if (backup && !nob_rename(backup, dst))
            nob_log(NOB_ERROR, "Restore the original from %s", backup);
        return false;
    }
    nob_log(NOB_INFO, "Linked %s -> %s", dst, src);
    return true;
}

static bool check_source(const char *src, bool directory) {
    struct stat info;
    if (stat(src, &info) != 0) {
        nob_log(NOB_ERROR, "Cannot read source %s: %s", src, strerror(errno));
        return false;
    }
    if (directory ? !S_ISDIR(info.st_mode) : !S_ISREG(info.st_mode)) {
        nob_log(NOB_ERROR, "Unexpected source type: %s", src);
        return false;
    }
    return true;
}
#endif

int main(int argc, char **argv) {
    NOB_GO_REBUILD_URSELF_PLUS(argc, argv, "nob.h");
    bool dry_run = false;
#ifdef _WIN32
    const char *target_home = getenv("USERPROFILE");
#else
    const char *target_home = getenv("HOME");
#endif
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--dry-run") == 0) dry_run = true;
        else if (strcmp(argv[i], "--home") == 0 && i + 1 < argc) target_home = argv[++i];
        else if (strcmp(argv[i], "--help") == 0) {
            puts("Run from the dotfiles repository: ./nob [--dry-run] [--home ABSOLUTE_PATH]");
            return 0;
        } else {
            nob_log(NOB_ERROR, "Unknown or incomplete option: %s", argv[i]);
            return 1;
        }
    }
    if (!target_home || !*target_home) {
        nob_log(NOB_ERROR, "Home directory is unset; use --home ABSOLUTE_PATH");
        return 1;
    }
    const char *root = get_current_dir_temp();
    if (!root) return 1;
#ifdef _WIN32
    // New-Item is a PowerShell cmdlet, not an executable. Keep Windows installation in one script.
    Cmd cmd = {0};
    cmd_append(&cmd, "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
        temp_sprintf("%s/windows.ps1", root), "-TargetHome", target_home);
    if (dry_run) cmd_append(&cmd, "-DryRun");
    bool ok = cmd_run(&cmd);
    free(cmd.items);
    return ok ? 0 : 1;
#else
    if (target_home[0] != '/') {
        nob_log(NOB_ERROR, "--home must be an absolute path");
        return 1;
    }
    // Validate all inputs before replacing any destination.
    for (size_t i = 0; i < NOB_ARRAY_LEN(items); ++i) {
        size_t mark = temp_save();
        bool ok = check_source(temp_sprintf("%s/%s", root, items[i].src), items[i].directory);
        temp_rewind(mark);
        if (!ok) return 1;
    }
    for (size_t i = 0; i < NOB_ARRAY_LEN(items); ++i) {
        size_t mark = temp_save();
        bool ok = install_link(temp_sprintf("%s/%s", root, items[i].src),
            temp_sprintf("%s/%s", target_home, items[i].dst),
            temp_sprintf("%s/.dotfiles-backups/%s", target_home, items[i].dst), dry_run);
        temp_rewind(mark);
        if (!ok) return 1;
    }
    return 0;
#endif
}
