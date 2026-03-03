# e - Directory Shortcut Manager

A simple command-line tool for quickly jumping to frequently used directories using shortcuts.

## Installation

Run the installation script:

```bash
./install_e.sh
```

Then reload your shell configuration:

```bash
source ~/.bashrc  # for bash
source ~/.zshrc   # for zsh
```

## Usage

### Add a shortcut
```bash
e -add www /var/www/html
e -add projects ~/Projects
```

### Jump to a shortcut
```bash
e www           # jumps to /var/www/html
e projects      # jumps to ~/Projects
```

### List all shortcuts
```bash
e -list
```

### Remove a shortcut
```bash
e -rm www
```

### Show help
```bash
e -h
```

## How it works

- Shortcuts are stored in `~/.e_shortcuts`
- The `e` command is a shell function that wraps `e.sh`
- When jumping to a shortcut, it uses `cd` to change your current directory
- When managing shortcuts (-add, -rm, -list), it calls the script directly

## Examples

```bash
# Add shortcuts for common locations
e -add www /var/www/html
e -add logs /var/log
e -add config /etc/nginx

# Jump around quickly
e www          # now in /var/www/html
e logs         # now in /var/log
e config       # now in /etc/nginx

# See all your shortcuts
e -list
```
