#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"

#include <stdio.h>
#include <stdlib.h>

typedef enum {
    TYPE_DIRECTORY,
    TYPE_FILE,
} item_type_t;

typedef struct transfer_item_t {
    item_type_t type;
    char* src;
    char* dst;
} transfer_item;

#ifdef _WIN32
#define BUFFER_SIZE (3 * 32767 + 1)
static transfer_item items[] = {
    {.type = TYPE_DIRECTORY, .src = "nvim", .dst = "AppData\\Local\\nvim"},
    {.type = TYPE_DIRECTORY, .src = ".glzr", .dst = ".glzr"},
    {.type = TYPE_FILE, .src = "wezterm", .dst = ".config\\wezterm"},
};
#else
#define BUFFER_SIZE 4096
static transfer_item items[] = {
    {.type = TYPE_FILE, .src = ".clang-format", .dst = ""},
    {.type = TYPE_DIRECTORY, .src = "nvim", .dst = ".config/"},
    {.type = TYPE_FILE, .src = ".zshrc", .dst = ""},
};
#endif

int main(int argc, char** argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

#ifdef _WIN32
    const char* home = getenv("USERPROFILE");
    if (home == NULL) {
        nob_log(NOB_ERROR, "Could not get USERPROFILE environment variable");
        return 1;
    }
#else
    const char* home = getenv("HOME");
    if (home == NULL) {
        nob_log(NOB_ERROR, "Could not get HOME environment variable");
        return 1;
    }
#endif

    char src_buf[BUFFER_SIZE];
    char dst_buf[BUFFER_SIZE];

    // TODO: use async cmd_run() instead
    Procs procs = {0};
    Cmd cmd = {0};
    for (size_t i = 0; i < NOB_ARRAY_LEN(items); ++i) {
        transfer_item item = items[i];
#ifdef _WIN32
        switch (item.type) {
        case TYPE_DIRECTORY:
            snprintf(src_buf, BUFFER_SIZE, "%s\\%s", home, item.src);
            snprintf(dst_buf, BUFFER_SIZE, "%s\\%s", home, item.dst);
            cmd_append(&cmd, "cmd", "/c", "mklink", "/J", dst_buf, src_buf);
            break;
        case TYPE_FILE:
            snprintf(src_buf, BUFFER_SIZE, "%s\\%s", home, item.src);
            snprintf(dst_buf, BUFFER_SIZE, "%s\\%s", home, item.dst);
            cmd_append(&cmd, "cmd", "/c", "mlink", dst_buf, src_buf);
            break;
        }
#else
        snprintf(src_buf, BUFFER_SIZE, "%s/.dotfiles/%s", home, item.src);
        snprintf(dst_buf, BUFFER_SIZE, "%s/%s", home, item.dst);
        cmd_append(&cmd, "ln", "-sf", src_buf, dst_buf);
#endif
        if (!cmd_run(&cmd, .async = &procs, .max_procs = 8)) {
            nob_log(NOB_ERROR, "Could not create symlink %s -> %s", dst_buf, src_buf);
        }
        cmd.count = 0;
    }
    procs_flush(&procs);

    return 0;
}
