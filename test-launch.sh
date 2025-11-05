#!/usr/bin/env bash
clear

# Launch function - displays and runs commands with inverse video highlighting
Launch() {
    # Print arrows normally, then command with inverse video
    echo -e "\e[1;93m▶▶▶\e[0m \e[1m\e[7m$*\e[0m"
    
    # Execute the command
    "$@"
    
    # Explicit reset with newline
    echo -e '\e[0m'
}

echo "Testing Launch function..."
echo "======================================"
echo

echo "Test 1: Simple command (uname -a)"
Launch uname -a
echo

echo "Test 2: Command with pipes (ls -la | head -5)"
Launch ls -la | head -5
echo

echo "Test 3: Command with output redirection"
Launch echo "Hello World" > /tmp/test-launch.txt
cat /tmp/test-launch.txt
rm /tmp/test-launch.txt
echo

echo "All tests complete!"

