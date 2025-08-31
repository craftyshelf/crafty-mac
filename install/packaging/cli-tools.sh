#!/bin/bash

step "Installing command-line tools"

if ! prompt_to_continue "Install CLI development tools?"; then
    return 0
fi

# Read CLI tools from config
if ! mapfile -t cli_tools < <(read_package_list "$CONFIG_DIR/packages/cli-tools.txt" "CLI tools"); then
    warn "No CLI tools to install"
    return 0
fi

total=${#cli_tools[@]}
current=0

log "Installing $total CLI tools..."

for tool in "${cli_tools[@]}"; do
    ((current++))
    show_progress $current $total "Installing $tool"

    if brew list "$tool" &>/dev/null; then
        continue  # Already installed
    fi

    if ! brew install "$tool" 2>/dev/null; then
        warn "Failed to install $tool"
    fi
done

success "CLI tools installation completed"
