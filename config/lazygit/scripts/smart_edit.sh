#!/bin/bash

# Detect if we're running inside Neovim (via NVIM environment variable)
if [[ -n "$NVIM" ]]; then
    IN_NVIM=true
else
    IN_NVIM=false
fi

# Open a file (optionally at a line) in the parent Neovim, or a new one
open_file() {
    local file="$1"
    local line="$2"

    if [[ "$IN_NVIM" == true ]]; then
        file="$(realpath -m -- "$file")"
        # Close lazygit, wait for its terminal window to go away, then open
        # the file in the parent Neovim. Detached so lazygit exiting can't kill it.
        nvim --server "$NVIM" --remote-send 'q'
        setsid bash -c '
            for _ in $(seq 50); do
                [[ "$(nvim --server "$NVIM" --remote-expr "&buftype")" != terminal ]] && break
                sleep 0.05
            done
            nvim --server "$NVIM" --remote "$1"
            if [[ -n "$2" ]]; then
                nvim --server "$NVIM" --remote-send "<C-\\><C-n>:$2<CR>zz"
            fi
        ' _ "$file" "$line" >/dev/null 2>&1 < /dev/null &
    else
        if [[ -n "$line" ]]; then
            exec nvim "+$line" "$file"
        else
            exec nvim "$file"
        fi
    fi
}

# If we got a line number (e.g., +545), use it directly
if [[ "$1" == +* ]]; then
    open_file "$2" "${1:1}"
    exit 0
fi

filename="$1"

# Check if file exists
if [[ ! -f "$filename" ]]; then
    open_file "$filename"
    exit 0
fi

# Find the first changed line (staged+unstaged vs HEAD, then unstaged only)
first_line=$(git diff HEAD -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')
if [[ ! "$first_line" =~ ^[0-9]+$ ]]; then
    first_line=$(git diff -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')
fi

if [[ "$first_line" =~ ^[0-9]+$ ]]; then
    open_file "$filename" "$first_line"
else
    open_file "$filename"
fi
