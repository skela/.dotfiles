# tmux-functions.sh

check_pane_condition() {
	local pane_count=$(tmux list-panes | wc -l)
	local is_zoomed=$(tmux display-message -p "#{window_zoomed_flag}")

	if [ "$pane_count" -gt 1 ] && [ "$is_zoomed" == 0 ]; then
		tmux set-option -Fw pane-active-border fg=red
	else
		tmux set-option -Fw pane-active-border fg=gray
	fi

}

check_window_condition() {
	local window_count=$(tmux list-windows | wc -l)

	if [ "$window_count" -lt 2 ]; then
		tmux set status off
		tmux set-window-option pane-border-status off
	else
		tmux set status on
		tmux set-window-option pane-border-status top
	fi
}

check_pane_condition

check_window_condition

exit 0
