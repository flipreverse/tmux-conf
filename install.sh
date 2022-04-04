#!/bin/bash
if [ -e "$HOME/.tmux.conf" ]; then
	printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
fi
cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true

cp -a ./tmux/. $HOME/.tmux/
ln -sf .tmux/tmux.conf $HOME/.tmux.conf

echo ". $HOME/.tmux/start-tmux.sh" >> $HOME/.profile
