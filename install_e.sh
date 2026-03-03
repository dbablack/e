#!/usr/bin/env bash

# Installation script for e shortcut tool

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
E_SCRIPT="${SCRIPT_DIR}/e.sh"

echo "Installing 'e' command..."

# Detect shell - check both current shell and default shell
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="${HOME}/.zshrc"
    SHELL_NAME="zsh"
elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="${HOME}/.bashrc"
    SHELL_NAME="bash"
else
    echo "Unsupported shell. Please manually add the function to your shell RC file."
    exit 1
fi

# Create the function to add to shell RC
FUNCTION_DEF="
# e - Directory shortcut manager
e() {
    if [[ \"\$1\" == \"-add\" ]] || [[ \"\$1\" == \"-rm\" ]] || [[ \"\$1\" == \"-list\" ]] || [[ \"\$1\" == \"-h\" ]] || [[ \"\$1\" == \"--help\" ]] || [[ -z \"\$1\" ]]; then
        # For add, remove, list, help, just run the script
        ${E_SCRIPT} \"\$@\"
    else
        # For jumping to a shortcut, get the path and cd to it
        local target=\$(${E_SCRIPT} \"\$1\")
        if [[ \$? -eq 0 ]] && [[ -n \"\$target\" ]]; then
            cd \"\$target\" || echo \"Error: Could not change to directory: \$target\"
        fi
    fi
}
"

# Check if function already exists in RC file
if grep -q "# e - Directory shortcut manager" "$SHELL_RC" 2>/dev/null; then
    echo "'e' function already exists in $SHELL_RC"
    echo "Please remove the old version and run this script again, or source your RC file."
else
    # Add function to RC file
    echo "$FUNCTION_DEF" >> "$SHELL_RC"
    echo "✓ Added 'e' function to $SHELL_RC"
fi

echo ""
echo "Installation complete!"
echo ""
echo "To start using 'e' immediately, run:"
echo "  source $SHELL_RC"
echo ""
echo "Usage:"
echo "  e -add <name> <path>    Add a new shortcut"
echo "  e -rm <name>            Remove a shortcut"
echo "  e -list                 List all shortcuts"
echo "  e <name>                Jump to shortcut directory"
echo ""
echo "Example:"
echo "  e -add www /var/www/html"
echo "  e www"
