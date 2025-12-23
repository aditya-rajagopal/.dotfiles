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

static const char* get_user_home(void);
static void create_symlink(Cmd* cmd, transfer_item item, char* src_buf, char* dst_buf);

static const char* home = NULL;
static const char* cwd = NULL;

int main(int argc, char** argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

    char src_buf[BUFFER_SIZE];
    char dst_buf[BUFFER_SIZE];
    cwd = nob_get_current_dir_temp();
    home = get_user_home();
    if (home == NULL)
        return 1;
    if (cwd == NULL)
        return 1;

    // @TODO add ability to run other types of commands
    Procs procs = {0};
    Cmd cmd = {0};
    for (size_t i = 0; i < NOB_ARRAY_LEN(items); ++i) {
        create_symlink(&cmd, items[i], src_buf, dst_buf);
        if (!cmd_run(&cmd, .async = &procs, .max_procs = 8)) {
            nob_log(NOB_ERROR, "Could not create symlink %s -> %s", dst_buf, src_buf);
        }
        cmd.count = 0;
    }
    procs_flush(&procs);

    return 0;
}

static const char* get_user_home(void) {
#ifdef _WIN32
    const char* home = getenv("USERPROFILE");
    if (home == NULL) {
        nob_log(NOB_ERROR, "Could not get USERPROFILE environment variable");
        return NULL;
    }
#else
    const char* home = getenv("HOME");
    if (home == NULL) {
        nob_log(NOB_ERROR, "Could not get HOME environment variable");
        return NULL;
    }
#endif
    return home;
}

static void create_symlink(Cmd* cmd, transfer_item item, char* src_buf, char* dst_buf) {
#ifdef _WIN32
    switch (item.type) {
    case TYPE_DIRECTORY:
        snprintf(src_buf, BUFFER_SIZE, "%s\\%s", home, item.src);
        snprintf(dst_buf, BUFFER_SIZE, "%s\\%s", home, item.dst);
        cmd_append(cmd, "cmd", "/c", "mklink", "/J", dst_buf, src_buf);
        break;
    case TYPE_FILE:
        snprintf(src_buf, BUFFER_SIZE, "%s\\%s", home, item.src);
        snprintf(dst_buf, BUFFER_SIZE, "%s\\%s", home, item.dst);
        cmd_append(cmd, "cmd", "/c", "mlink", dst_buf, src_buf);
        break;
    }
#else
    snprintf(src_buf, BUFFER_SIZE, "%s/%s", cwd, item.src);
    snprintf(dst_buf, BUFFER_SIZE, "%s/%s", home, item.dst);
    cmd_append(cmd, "ln", "-sf", src_buf, dst_buf);
#endif
}
