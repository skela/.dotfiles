#!/bin/bash

# If we got a line number (e.g., +545), just pass through to nvim
if [[ "$1" == +* ]]; then
    exec nvim "$@"
fi

# Otherwise, find the first changed line
filename="$1"

# Check if file exists
if [[ ! -f "$filename" ]]; then
    exec nvim "$filename"
    exit
fi

# Get the first changed line from git diff
first_line=$(git diff HEAD -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')

# If we found a line number, use it; otherwise just open the file
if [[ -n "$first_line" ]] && [[ "$first_line" =~ ^[0-9]+$ ]]; then
    exec nvim "+$first_line" "$filename"
else
    # Check unstaged changes if no staged changes found
    first_line=$(git diff -- "$filename" | grep -m1 "^@@" | sed 's/^@@ -[0-9,]* +\([0-9]*\).*/\1/')
    if [[ -n "$first_line" ]] && [[ "$first_line" =~ ^[0-9]+$ ]]; then
        exec nvim "+$first_line" "$filename"
    else
        exec nvim "$filename"
    fi
fi
