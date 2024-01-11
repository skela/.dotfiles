# tmux-functions.sh

check_pane_condition() {
	local pane_count=$(tmux list-panes | wc -l)
	local is_zoomed=$(tmux display-message -p "#{window_zoomed_flag}")

	# tmux display-message "pane count: $pane_count and is_zoomed: $is_zoomed"

	if [ "$pane_count" -gt 1 ] && [ "$is_zoomed" == 0 ]; then
		tmux set-option -Fw pane-active-border fg=red
	else
		tmux set-option -Fw pane-active-border fg=gray
	fi
}

check_pane_condition

exit 0
