#!/bin/bash
#
#    Put '. $HOME/.tmux/start-tmux.sh' at the end of $HOME/.profile
#    to automatically start tmux on login
#
#    Copyright (C) 2008 Canonical Ltd.
#    Copyright (C) 2011-2014 Dustin Kirkland
#    Copyright (C) 2022 Alexander Lochmann
#
#    Authors: Dustin Kirkland <kirkland@byobu.org>
#             Alexander Lochmann <info@alexander-lochmann.de>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#    Using shamelessly stolen parts from /usr/bin/byobu-launch{,er}

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
	case "$-" in
		*i*)
			# Attempt to merge shell history across sessions/windows (works with some exceptions)
			for i in shopt setopt;
			do
				if eval $BYOBU_TEST $i >/dev/null; then
					case $i in
						shopt) $i -s histappend || true ;;
						setopt) $i appendhistory || true ;;
					esac
				fi
			done
			[ -n "$PROMPT_COMMAND" ] && PROMPT_COMMAND="history -a;history -r;$PROMPT_COMMAND" || PROMPT_COMMAND="history -a;history -r"
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
		;;
	esac

fi
unset _tty
true
