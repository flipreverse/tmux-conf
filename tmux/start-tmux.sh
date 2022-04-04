#!/bin/bash

# Shamelessly stolen from /usr/bin/byobu-launch{,er}
_tty=$(tty)
if [ "${_tty#/dev/ttyS}" != "$_tty" ] && [ "${_tty#/dev/ttyAMA}" != "$_tty" ]; then
	# Don't autolaunch tmux on serial consoles
	# You can certainly run 'tmux' manually, though
	echo
	echo "INFO: Disabling auto-launch of tmux on this serial console"
	echo "INFO: You can still run 'tmux' manually at the command line"
	echo
elif [ -z ${TMUX} ];
then
	case "$TERM" in
		*screen*)
			# Handle nesting
			if [ -n "$SSH_CONNECTION" ] && [ "$(printf "$SSH_CONNECTION" | awk '{print $1}')" != "$(printf "$SSH_CONNECTION" | awk '{print $3}')" ]; then
				# Safeguard against ssh-ing into ourself, which causes an infinite loop
				$HOME/.tmux/tmux-select-session.py
			else
				echo "INFO: Disabling auto-launch of tmux in this SSH connection, to avoid a potential infinite loop" 1>&2
				echo "INFO: You can still run 'tmux' manually at the command line, if you know what you're doing" 1>&2
				true
			fi
		;;
		dumb)
			# Dumb terminal, don't launch
			false
		;;
		*)
			$HOME/.tmux/tmux-select-session.py
		;;
	esac
	# Wait very briefly for the no-logout flag to get written?
	sleep 0.1
	if [ -e "$HOME/.tmux/no-logout" ]; then
		# The user does not want to logout on byobu detach
		rm -f "$HOME/.tmux/no-logout"	# Remove one-time no-logout flag, if it exists
		true
	else
		exit 0
	fi
fi
unset _tty
true
