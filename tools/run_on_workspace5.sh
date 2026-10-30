#!/usr/bin/env bash
"$@" &
pid=$!
for _ in $(seq 1 150); do
	window=$(xdotool search --pid "$pid" --onlyvisible 2>/dev/null | head -1)
	[ -n "$window" ] && break
	sleep 0.1
done
[ -n "$window" ] && i3-msg "[id=$window] move container to workspace number 5" >/dev/null
wait "$pid"
