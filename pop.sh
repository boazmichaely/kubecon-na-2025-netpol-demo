#!/usr/bin/env bash

# Set the window title to search for (bash variable)
WINDOW_TITLE="${1:-Online Boutique}"

osascript <<EOF
tell application "System Events"
	set theTitle to "$WINDOW_TITLE"
	set theProcesses to every process where background only is false
	repeat with theProcess in theProcesses
		tell theProcess
			repeat with theWindow in windows
				if name of theWindow contains theTitle then
					tell theWindow to perform action "AXRaise"
					set frontmost of theProcess to true
					return
				end if
			end repeat
		end tell
	end repeat
end tell
EOF