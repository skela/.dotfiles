#!/bin/bash

# Detect if we're running inside Neovim (via NVIM environment variable)
if [[ -n "$NVIM" ]] && command -v nvr &> /dev/null; then
    IN_NVIM=true
else
    IN_NVIM=false
fi

# Function to close lazygit
close_lazygit() {
    if [[ "$IN_NVIM" == true ]]; then
        nvr --remote-send 'q'
    fi
}

# If we got a line number (e.g., +545), extract it and handle separately
if [[ "$1" == +* ]]; then
    line_num="${1:1}"  # Remove the + prefix
    filename="$2"
    
    if [[ "$IN_NVIM" == true ]]; then
        close_lazygit
        # Use nvr with -c to execute command after opening
        nvr --remote "$filename" -c "$line_num" -c "normal! zz"
    else
        exec nvim "+$line_num" "$filename"
    fi
    exit 0
fi

# Otherwise, find the first changed line
filename="$1"

# Check if file exists
if [[ ! -f "$filename" ]]; then
    if [[ "$IN_NVIM" == true ]]; then
        close_lazygit
        nvr --remote "$filename"
    else
        exec nvim "$filename"
    fi
    exit 0
fi

# Get the first changed line from git diff
first_line=$(git diff HEAD -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')

# If we found a line number, use it; otherwise just open the file
if [[ -n "$first_line" ]] && [[ "$first_line" =~ ^[0-9]+$ ]]; then
    if [[ "$IN_NVIM" == true ]]; then
        close_lazygit
        nvr --remote "$filename" -c "$first_line" -c "normal! zz"
    else
        exec nvim "+$first_line" "$filename"
    fi
else
    # Check unstaged changes if no staged changes found
    first_line=$(git diff -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')
    if [[ -n "$first_line" ]] && [[ "$first_line" =~ ^[0-9]+$ ]]; then
        if [[ "$IN_NVIM" == true ]]; then
            close_lazygit
            nvr --remote "$filename" -c "$first_line" -c "normal! zz"
        else
            exec nvim "+$first_line" "$filename"
        fi
    else
        if [[ "$IN_NVIM" == true ]]; then
            close_lazygit
            nvr --remote "$filename"
        else
            exec nvim "$filename"
        fi
    fi
fi
