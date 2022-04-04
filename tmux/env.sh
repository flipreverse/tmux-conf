#!/bin/bash

BYOBU_TEST=which

# Stolen from /usr/lib/byobu/include/icons
if [[ "$LANG" =~ "UTF-8" ]];
then
	ICON_REBOOT="⟳"
	ICON_UPDATES="!"
	ICON_UPGRADE="⚠"
	ICON_SECURITY="‼"
else
	ICON_REBOOT="(R)"
        ICON_UPDATES="!"
        ICON_UPGRADE="/!\\\\\\"
        ICON_SECURITY="!!"
fi

CACHE_DIR=$HOME/.tmux/cache
if [ ! -d ${CACHE_DIR} ];
then
	mkdir -p ${CACHE_DIR}
fi

STATUS_DIR=$HOME/.tmux/status/
if [ ! -d ${STATUS_DIR} ];
then
	mkdir -p ${STATUS_DIR}
fi
