#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"

#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 1024

typedef struct transfer_item_t {
    char* src;
    char* dst;
} transfer_item;

static transfer_item items[] = {
    {.src = ".clang-format", .dst = ""},
    {.src = "nvim", .dst = ".config/"},
    {.src = ".zshrc", .dst = ""},
};

int main(int argc, char** argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

    const char* home = getenv("HOME");
    if (home == NULL) {
        nob_log(NOB_ERROR, "Could not get HOME environment variable");
        return 1;
    }

    char src_buf[BUFFER_SIZE];
    char dst_buf[BUFFER_SIZE];

    // TODO: use async cmd_run() instead
    Procs procs = {0};
    Cmd cmd = {0};
    for (size_t i = 0; i < NOB_ARRAY_LEN(items); ++i) {
        transfer_item item = items[i];
        snprintf(src_buf, BUFFER_SIZE, "%s/.dotfiles/%s", home, item.src);
        snprintf(dst_buf, BUFFER_SIZE, "%s/%s", home, item.dst);
        cmd_append(&cmd, "ln", "-sf", src_buf, dst_buf);
        if (!cmd_run(&cmd, .async = &procs, .max_procs = 8)) {
            nob_log(NOB_ERROR, "Could not create symlink %s -> %s", dst_buf, src_buf);
        }
        cmd.count = 0;
    }
    procs_flush(&procs);

    return 0;
}
