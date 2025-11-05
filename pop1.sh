#!/usr/bin/env bash

# Test script to bring specific Chrome window to front

echo "Current Chrome windows:"
osascript -e 'tell application "Google Chrome" to get title of every window'
echo ""

# Test with window title passed as argument
WINDOW_TITLE="${1:Online Boutique}"

echo "Attempting to activate window containing: '$WINDOW_TITLE'"

# Try method 1: System Events approach
osascript <<EOF
tell application "System Events"
    tell process "Google Chrome"
        set frontmost to true
        repeat with aWindow in windows
            if (title of aWindow) contains "$WINDOW_TITLE" then
                perform action "AXRaise" of aWindow
                exit repeat
            end if
        end repeat
    end tell
end tell
EOF

echo "Done!"

