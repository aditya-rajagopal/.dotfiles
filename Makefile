.DEFAULT_GOAL := push_files

ifeq ($(OS),Windows_NT)
NOB := nob.exe
else
NOB := nob
endif

.PHONY: push_files bootstrap dry-run test

push_files: $(NOB)
	./$(NOB) $(NOB_ARGS)

$(NOB): nob.c nob.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ nob.c $(LDFLAGS)

bootstrap: $(NOB)

dry-run: $(NOB)
	./$(NOB) --dry-run $(NOB_ARGS)

test:
	python3 tests/test_install.py
