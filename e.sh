#!/usr/bin/env bash

# e.sh - Directory shortcut manager
# Storage file for shortcuts
SHORTCUTS_FILE="${HOME}/.e_shortcuts"

# Initialize shortcuts file if it doesn't exist
if [[ ! -f "$SHORTCUTS_FILE" ]]; then
    touch "$SHORTCUTS_FILE"
fi

# Function to show usage
show_usage() {
    echo "Usage:"
    echo "  e -add <name> <path>    Add a new shortcut"
    echo "  e -rm <name>            Remove a shortcut"
    echo "  e -list                 List all shortcuts"
    echo "  e <name>                Jump to shortcut directory"
}

# Function to add a shortcut
add_shortcut() {
    local name="$1"
    local path="$2"
    
    if [[ -z "$name" || -z "$path" ]]; then
        echo "Error: Both name and path are required"
        echo "Usage: e -add <name> <path>"
        return 1
    fi
    
    # Resolve to absolute path
    if [[ -d "$path" ]]; then
        path=$(cd "$path" && pwd)
    else
        echo "Warning: Directory does not exist yet: $path"
        # Convert to absolute path anyway
        path=$(realpath -m "$path" 2>/dev/null || echo "$path")
    fi
    
    # Check if shortcut already exists
    if grep -q "^${name}:" "$SHORTCUTS_FILE" 2>/dev/null; then
        # Update existing shortcut
        sed -i.bak "s|^${name}:.*|${name}:${path}|" "$SHORTCUTS_FILE"
        echo "Updated shortcut: $name -> $path"
    else
        # Add new shortcut
        echo "${name}:${path}" >> "$SHORTCUTS_FILE"
        echo "Added shortcut: $name -> $path"
    fi
}

# Function to remove a shortcut
remove_shortcut() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        echo "Error: Shortcut name is required"
        echo "Usage: e -rm <name>"
        return 1
    fi
    
    if grep -q "^${name}:" "$SHORTCUTS_FILE" 2>/dev/null; then
        sed -i.bak "/^${name}:/d" "$SHORTCUTS_FILE"
        echo "Removed shortcut: $name"
    else
        echo "Error: Shortcut not found: $name"
        return 1
    fi
}

# Function to list all shortcuts
list_shortcuts() {
    if [[ ! -s "$SHORTCUTS_FILE" ]]; then
        echo "No shortcuts defined yet."
        echo "Add one with: e -add <name> <path>"
        return 0
    fi
    
    echo "Available shortcuts:"
    while IFS=: read -r name path; do
        printf "  %-15s -> %s\n" "$name" "$path"
    done < "$SHORTCUTS_FILE"
}

# Function to get shortcut path
get_shortcut() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        show_usage
        return 1
    fi
    
    local path=$(grep "^${name}:" "$SHORTCUTS_FILE" 2>/dev/null | cut -d: -f2-)
    
    if [[ -z "$path" ]]; then
        echo "Error: Shortcut not found: $name"
        echo "Use 'e -list' to see available shortcuts"
        return 1
    fi
    
    echo "$path"
}

# Main logic
case "$1" in
    -add)
        add_shortcut "$2" "$3"
        ;;
    -rm)
        remove_shortcut "$2"
        ;;
    -list)
        list_shortcuts
        ;;
    -h|--help|"")
        show_usage
        ;;
    *)
        # Try to jump to shortcut
        get_shortcut "$1"
        ;;
esac
