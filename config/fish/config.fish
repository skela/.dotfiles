
set -U fish_user_paths $fish_user_paths $HOME/.local/bin/

# Definitions
set TERM screen-256color
set EDITOR vim
set VISUAL vim
set BROWSER firefox-developer-edition

# Settings
set fish_greeting
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hg_prompt_enabled no
set -g theme_svn_prompt_enabled no
set -g fish_prompt_pwd_dir_length 0

fish_config theme choose tokyonight

# Colors
# set -g color_dir_bg f7768e
# set -g color_dir_str ffffff
set -g color_user_str ffffff

set -g current_bg NONE
set segment_separator \uE0B0
set right_segment_separator \uE0B0
set -q scm_prompt_blacklist; or set scm_prompt_blacklist

# ===========================
# Color setting

# You can set these variables in config.fish like:
# set -g color_dir_bg red
# If not set, default color from agnoster will be used.
# ===========================

set -q color_virtual_env_bg; or set color_virtual_env_bg white
set -q color_virtual_env_str; or set color_virtual_env_str black
set -q color_user_bg; or set color_user_bg black
set -q color_user_str; or set color_user_str yellow
set -q color_dir_bg; or set color_dir_bg blue
set -q color_dir_str; or set color_dir_str black
set -q color_hg_changed_bg; or set color_hg_changed_bg yellow
set -q color_hg_changed_str; or set color_hg_changed_str black
set -q color_hg_bg; or set color_hg_bg green
set -q color_hg_str; or set color_hg_str black
set -q color_git_dirty_bg; or set color_git_dirty_bg yellow
set -q color_git_dirty_str; or set color_git_dirty_str black
set -q color_git_bg; or set color_git_bg green
set -q color_git_str; or set color_git_str black
set -q color_svn_bg; or set color_svn_bg green
set -q color_svn_str; or set color_svn_str black
set -q color_status_nonzero_bg; or set color_status_nonzero_bg black
set -q color_status_nonzero_str; or set color_status_nonzero_str red
set -q color_status_superuser_bg; or set color_status_superuser_bg black
set -q color_status_superuser_str; or set color_status_superuser_str yellow
set -q color_status_jobs_bg; or set color_status_jobs_bg black
set -q color_status_jobs_str; or set color_status_jobs_str cyan
set -q color_status_private_bg; or set color_status_private_bg black
set -q color_status_private_str; or set color_status_private_str purple

# ===========================
# Git settings
# set -g color_dir_bg red

set -q fish_git_prompt_untracked_files; or set fish_git_prompt_untracked_files normal

# ===========================
# Subversion settings

set -q theme_svn_prompt_enabled; or set theme_svn_prompt_enabled no

# ===========================
# Helper methods
# ===========================

set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_dirtystate '±'
set -g __fish_git_prompt_char_cleanstate ''

function parse_git_dirty
    if [ $__fish_git_prompt_showdirtystate = yes ]
        set -l submodule_syntax
        set submodule_syntax "--ignore-submodules=dirty"
        set untracked_syntax "--untracked-files=$fish_git_prompt_untracked_files"
        set git_dirty (command git status --porcelain $submodule_syntax $untracked_syntax 2> /dev/null)
        if [ -n "$git_dirty" ]
            echo -n "$__fish_git_prompt_char_dirtystate"
        else
            echo -n "$__fish_git_prompt_char_cleanstate"
        end
    end
end

function cwd_in_scm_blacklist
    for entry in $scm_prompt_blacklist
        pwd | grep "^$entry" -
    end
end

# ===========================
# Segments functions
# ===========================

function prompt_segment -d "Function to draw a segment"
    set -l bg
    set -l fg
    if [ -n "$argv[1]" ]
        set bg $argv[1]
    else
        set bg normal
    end
    if [ -n "$argv[2]" ]
        set fg $argv[2]
    else
        set fg normal
    end
    if [ "$current_bg" != NONE -a "$argv[1]" != "$current_bg" ]
        set_color -b $bg
        set_color $current_bg
        echo -n "$segment_separator "
        set_color -b $bg
        set_color $fg
    else
        set_color -b $bg
        set_color $fg
        echo -n " "
    end
    set current_bg $argv[1]
    if [ -n "$argv[3]" ]
        echo -n -s $argv[3] " "
    end
end

function prompt_finish -d "Close open segments"
    if [ -n $current_bg ]
        set_color normal
        set_color $current_bg
        echo -n "$segment_separator "
        set_color normal
    end
    set -g current_bg NONE
    echo "
> "
end

# function postexec_test --on-event fish_postexec
#     echo
# end

# ===========================
# Theme components
# ===========================

function prompt_virtual_env -d "Display Python or Nix virtual environment"
    set envs

    if test "$VIRTUAL_ENV"
        set py_env (basename $VIRTUAL_ENV)
        set envs $envs "py[$py_env]"
    end

    if test "$IN_NIX_SHELL"
        set envs $envs "nix[$IN_NIX_SHELL]"
    end

    if test "$envs"
        prompt_segment $color_virtual_env_bg $color_virtual_env_str (string join " " $envs)
    end
end

function prompt_user -d "Display current user if different from $default_user"
    if [ "$theme_display_user" = yes ]
        if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
            set USER (whoami)
            get_hostname
            if [ $HOSTNAME_PROMPT ]
                set USER_PROMPT $USER@$HOSTNAME_PROMPT
            else
                set USER_PROMPT $USER
            end
            prompt_segment $color_user_bg $color_user_str $USER_PROMPT
        end
    else
        get_hostname
        if [ $HOSTNAME_PROMPT ]
            prompt_segment $color_user_bg $color_user_str $HOSTNAME_PROMPT
        end
    end
end

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT if connected via SSH"
    set -g HOSTNAME_PROMPT ""
    if [ "$theme_hide_hostname" = no -o \( "$theme_hide_hostname" != yes -a -n "$SSH_CLIENT" \) ]
        # set -g HOSTNAME_PROMPT (uname -n | string replace ".local" "" | string replace "domain" "")
        # set -g HOSTNAME_PROMPT (uname -n | string replace ".local" "" | string replace "domain" "" | sed 's/-[0-9]\+$//')
        set -g HOSTNAME_PROMPT (uname -n | string replace ".local" "" | string replace "domain" "" | string replace "-" "" | string replace "1" "" | string replace "2" "" | string replace "3" "" | string replace "4" "" | string replace "5" "" | string replace "6" "" | string replace "7" "" | string replace "8" "" | string replace "9" "")
    end
end

function prompt_dir -d "Display the current directory"
    prompt_segment $color_dir_bg $color_dir_str (prompt_pwd)
end


function prompt_hg -d "Display mercurial state"
    set -l branch
    set -l state
    if command hg id >/dev/null 2>&1
        set branch (command hg id -b)
        # We use `hg bookmarks` as opposed to `hg id -B` because it marks
        # currently active bookmark with an asterisk. We use `sed` to isolate it.
        set bookmark (hg bookmarks | sed -nr 's/^.*\*\ +\b(\w*)\ +.*$/:\1/p')
        set state (hg_get_state)
        set revision (command hg id -n)
        set branch_symbol \uE0A0
        set prompt_text "$branch_symbol $branch$bookmark:$revision"
        if [ "$state" = 0 ]
            prompt_segment $color_hg_changed_bg $color_hg_changed_str $prompt_text " ±"
        else
            prompt_segment $color_hg_bg $color_hg_str $prompt_text
        end
    end
end

function hg_get_state -d "Get mercurial working directory state"
    if hg status | grep --quiet -e "^[A|M|R|!|?]"
        echo 0
    else
        echo 1
    end
end

function copy_to_clipboard -d "Copy to clipboard"
    set -l str $argv[1]
    switch (uname -s)
        case Linux
            if test "$XDG_SESSION_TYPE" = wayland
                echo -n "$str" | wl-copy
            else
                echo -n "$str" | xclip -selection clipboard
            end
        case Darwin
            echo -n "$str" | pbcopy
    end
end

function gitl -d "Get URL for commit"
    begin
        set GIT_COMMIT (git rev-parse HEAD)
        set GIT_REMOTE_INFO (git remote get-url --all origin)
        set GIT_HOST (echo $GIT_REMOTE_INFO | cut -d ':' -f1 | string replace --filter "git@" "" | string trim)
        set GIT_REPO (echo $GIT_REMOTE_INFO | cut -d ':' -f2 | cut -d ' ' -f1 | string replace --filter ".git" "")
        set GIT_LINK (printf 'https://%s/%s/commit/%s' $GIT_HOST $GIT_REPO $GIT_COMMIT)
        echo $GIT_LINK
        copy_to_clipboard $GIT_LINK
    end
end

function gitln -d "Get URL for GitHub Network"
    begin
        set GIT_REMOTE_INFO (git remote get-url --all origin)
        set GIT_HOST (echo $GIT_REMOTE_INFO | cut -d ':' -f1 | string replace --filter "git@" "" | string trim)
        set GIT_REPO (echo $GIT_REMOTE_INFO | cut -d ':' -f2 | cut -d ' ' -f1 | string replace --filter ".git" "")
        set GIT_LINK (printf 'https://%s/%s/network' $GIT_HOST $GIT_REPO)
        echo $GIT_LINK
        copy_to_clipboard $GIT_LINK
    end
end

function gito -d "Open Commit Link in Browser"
    begin
        firefox-developer-edition (gitl)
    end
end

function gitn -d "Open Github Network in Browser"
    begin
        firefox-developer-edition (gitln)
    end
end

function gitc -d "Get commit id"
    begin
        set GIT_COMMIT (git rev-parse HEAD)
        echo $GIT_COMMIT
        copy_to_clipboard $GIT_COMMIT
    end
end

function prompt_git -d "Display the current git state"
    set -l ref
    set -l dirty
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set dirty (parse_git_dirty)
        set ref (command git symbolic-ref HEAD 2> /dev/null)
        if [ $status -gt 0 ]
            set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
            set ref "➦ $branch "
        end
        set branch_symbol \uE0A0
        set -l branch (echo $ref | sed  "s-refs/heads/-$branch_symbol -")
        if [ "$dirty" != "" ]
            prompt_segment $color_git_dirty_bg $color_git_dirty_str "$branch $dirty"
        else
            prompt_segment $color_git_bg $color_git_str "$branch $dirty"
        end
    end
end


function prompt_svn -d "Display the current svn state"
    set -l ref
    if command svn info >/dev/null 2>&1
        set branch (svn_get_branch)
        set branch_symbol \uE0A0
        set revision (svn_get_revision)
        prompt_segment $color_svn_bg $color_svn_str "$branch_symbol $branch:$revision"
    end
end

function svn_get_branch -d "get the current branch name"
    svn info 2>/dev/null | awk -F/ \
        '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
end

function svn_get_revision -d "get the current revision number"
    svn info 2>/dev/null | sed -n 's/Revision:\ //p'
end


function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ $RETVAL -ne 0 ]
        prompt_segment $color_status_nonzero_bg $color_status_nonzero_str "✘"
    end

    if [ "$fish_private_mode" ]
        prompt_segment $color_status_private_bg $color_status_private_str "🔒"
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
        prompt_segment $color_status_superuser_bg $color_status_superuser_str "⚡"
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
        prompt_segment $color_status_jobs_bg $color_status_jobs_str "⚙"
    end
end

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
    status --is-command-substitution; and return

    # Check if we are inside a git directory
    if git rev-parse --show-toplevel &>/dev/null
        set gitdir (realpath (git rev-parse --show-toplevel))
        set cwd (pwd -P)
        # While we are still inside the git directory, find the closest
        # virtualenv starting from the current directory.
        while string match "$gitdir*" "$cwd" &>/dev/null
            if test -e "$cwd/.venv/bin/activate.fish"
                source "$cwd/.venv/bin/activate.fish" &>/dev/null
                uv sync -q
                return
            else
                set cwd (path dirname "$cwd")
            end
        end
    end
    # If virtualenv activated but we are not in a git directory, deactivate.
    if test -n "$VIRTUAL_ENV"
        deactivate
    end
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
    set -g RETVAL $status
    prompt_status
    prompt_virtual_env
    prompt_user
    prompt_dir
    if [ (cwd_in_scm_blacklist | wc -c) -eq 0 ]
        type -q git; and prompt_git
        if [ "$theme_hg_prompt_enabled" = yes ]
            type -q hg; and prompt_hg
        end
        if [ "$theme_svn_prompt_enabled" = yes ]
            type -q svn; and prompt_svn
        end
    end
    prompt_finish
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function ta -d "Tmux Attach"
    begin
        tmux a
    end
end

function start
    /home/skela/.dotfiles/.venv/bin/python3 ~/.dotfiles/scripts/start.py
end

function reload_signatures
    sudo pacman -Sy archlinux-keyring
    sudo pacman -Sy endeavouros-keyring
end

function ezals --wraps=eza --description 'Wrapper for eza with custom behavior'
    # Loop through the arguments, skipping flags and their values
    set -l dir_path ""
    set -l skip_next 0

    for arg in $argv
        # Skip the next argument if it's a value for a previous flag
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end

        # If the argument starts with a '-', it's a flag
        if string match -- -r '^-' $arg


            # Some flags (like --flag=value) have an argument attached
            if string match -- -r '^--?[^=]+=.*' $arg
                continue
            end

            # Flags like --flag or -f might expect the next argument to be their value
            if string match -- -r '^--?[^=]+' $arg
                set skip_next 1
            end
            continue
        end

        # If it's not a flag, assume it's the directory
        set dir_path $arg
        break
    end

    # Check if we found a directory argument, if not, use the current directory
    if test -z "$dir_path"
        set dir_path (pwd)
    end

    # Concatenate the directory with the .eza_ignore file
    set target_file "$dir_path/.hidden"

    # Test if the .eza_ignore file exists in the directory
    if test -e $target_file
        set DIR_EZA_IGNORE (cat $target_file | tr '\n' '|')
        eza --icons auto --color auto --no-git --no-quotes --ignore-glob "$DIR_EZA_IGNORE" $argv
    else
        eza $argv --icons auto --color auto --no-git --no-quotes --ignore-glob "$EZA_IGNORE"
    end
end

function ls
    ezals $argv
end

function ll
    ezals -l $argv
end

function lt
    ezals -T $argv
end

set -g _EZA_DEFAULT_ARGS --icons=auto --color=always --group-directories-first

function lsa
    eza -a $_EZA_DEFAULT_ARGS $argv
end

function lla
    eza -al $_EZA_DEFAULT_ARGS $argv
end

function lta
    eza -aT $_EZA_DEFAULT_ARGS $argv
end

function reload_variables -d "Reload Environment variables"
    switch (uname -s)
        case Linux
            set -xg CONTAINER_PROGRAM podman

            # set -xg FVM_CACHE_PATH "$HOME/files/sdks/fvm"
            # set -xg FLUTTER_HOME "$HOME/files/sdks/fvm/default"
            set -xg FLUTTER_HOME "$HOME/files/sdks/flutter"
            set -xg ANDROID_SDK_ROOT "$HOME/files/sdks/android"
            set -xg ANDROID_HOME "$ANDROID_SDK_ROOT"
            set -xg DOTNET_ROOT "$HOME/.dotnet"
            set -xg CARGO_ROOT "$HOME/.cargo"
            set -xg PULUMI_ROOT "$HOME/.pulumi"

            set -xg CHROME_EXECUTABLE /usr/bin/google-chrome-stable
            set -xg LLDB_USE_NATIVE_PDB_READER yes

            # set -x PATH "$HOME/.gem/ruby/2.7.0/bin" $PATH
            set -x PATH "$CARGO_ROOT/bin" $PATH
            # set -x PATH "$FLUTTER_HOME/bin" $PATH
            set -x PATH "$PULUMI_ROOT/bin" $PATH

            set -x PATH "$ANDROID_HOME/tools" $PATH
            set -x PATH "$ANDROID_HOME/tools/bin" $PATH
            set -x PATH "$ANDROID_HOME/platform-tools" $PATH

            set -x PATH "$DOTNET_ROOT" $PATH
            set -x PATH "$DOTNET_ROOT/tools" $PATH
        case Darwin
            set -xg FLUTTER_HOME "$HOME/Files/SDKs/flutter"

            set -x PATH "$FLUTTER_HOME/bin" $PATH
            set -x PATH "/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin" $PATH
            set -x PATH /usr/local/sbin $PATH
            set -x PATH /opt/homebrew/bin $PATH

            #export CPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
            #export C_INCLUDE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/"
            # export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    end
    set -x PATH "$HOME/.pub-cache/bin/" $PATH
    set -x PATH "$HOME/.local/bin/" $PATH
end

function reload_aliases -d "Reload aliases"

    if [ -f ~/.aliases ]
        . ~/.aliases
    end

    if [ -f ~/.dotfiles/aliases ]
        . ~/.dotfiles/aliases
    end

    switch (uname -s)
        case Linux
            if [ -f ~/.dotfiles/aliases_linux ]
                . ~/.dotfiles/aliases_linux
            end
        case Darwin
            if [ -f ~/.dotfiles/aliases_osx]
                . ~/.dotfiles/aliases_osx
            end
    end

    alias assume="source /usr/bin/assume.fish"
end

function reload -d "Reload Config"
    reload_aliases
    reload_variables
end

reload_aliases
reload_variables
