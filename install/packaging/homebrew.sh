#!/bin/bash

step "Setting up Homebrew package manager"

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    if prompt_to_continue "Install Homebrew package manager?"; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        success "Homebrew installed successfully"
    else
        error "Homebrew is required for this setup. Exiting."
        exit 1
    fi
else
    log "Homebrew already installed, updating..."
    brew update
fi

# Add required taps
log "Adding Homebrew taps..."
declare -a taps=(
    "homebrew/cask-fonts"
    "nikitabobko/tap"  # For AeroSpace
)

for tap in "${taps[@]}"; do
    if ! brew tap | grep -q "^$tap$"; then
        log "Adding tap: $tap"
        brew tap "$tap"
    fi
done

success "Homebrew setup completed"
