#!/bin/bash

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export YELLOW='\033[1;33m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m'

# Configuration
export USER=$(whoami)
export HOME_DIR="/Users/$USER"
export SETUP_DIR="$HOME/.local/share/craftymac"
export CONFIG_DIR="$SETUP_DIR/config"
export DOTFILES_REPO="https://github.com/craftyshelf/dotfiles.git"

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

step() {
    echo -e "\n${PURPLE}[STEP]${NC} $1"
}

# Enhanced prompt function
prompt_to_continue() {
    local message="$1"
    local default="${2:-y}"
    local choice

    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$(echo -e "${CYAN}$message${NC} [Y/n/q]: ")" choice
            choice=${choice:-y}
        else
            read -p "$(echo -e "${CYAN}$message${NC} [y/N/q]: ")" choice
            choice=${choice:-n}
        fi

        case "$choice" in
        [Yy])
            return 0
            ;;
        [Nn])
            warn "Skipping this step..."
            return 1
            ;;
        [Qq])
            error "Installation aborted by user"
            exit 1
            ;;
        *)
            error "Invalid choice. Please enter y, n, or q."
            ;;
        esac
    done
}

# Read app lists from config files with better error handling
read_package_list() {
    local file_path="$1"
    local package_type="${2:-packages}"

    if [[ ! -f "$file_path" ]]; then
        error "Config file $file_path not found."
        return 1
    fi

    local count=$(grep -c -v '^#\|^[[:space:]]*$' "$file_path" 2>/dev/null || echo "0")
    if [[ $count -eq 0 ]]; then
        warn "No $package_type found in $file_path"
        return 1
    fi

    log "Found $count $package_type in $(basename "$file_path")"
    grep -v '^#\|^[[:space:]]*$' "$file_path"
}

# Progress tracking
show_progress() {
    local current="$1"
    local total="$2"
    local task="$3"
    local percentage=$((current * 100 / total))

    printf "\r${BLUE}[%3d%%]${NC} %s" "$percentage" "$task"
    if [[ $current -eq $total ]]; then
        echo
    fi
}

# Cleanup function
cleanup_installation() {
    log "Performing cleanup..."

    if command -v brew &>/dev/null; then
        brew cleanup --prune=0 2>/dev/null || true
    fi

    # Remove temporary files
    rm -rf /tmp/craftymac-* 2>/dev/null || true
}

# Show completion message
show_completion_message() {
    clear
    echo -e "\n${GREEN}"
    echo "██████╗  ██████╗ ███╗   ██╗███████╗██╗"
    echo "██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║"
    echo "██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║"
    echo "██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝"
    echo "██████╔╝╚██████╔╝██║ ╚████║███████╗██╗"
    echo "╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝"
    echo -e "${NC}\n"

    success "macOS setup completed successfully!"
    echo
    log "Post-installation steps:"
    log "• Restart your terminal or run: exec fish"
    log "• Configure Tide prompt: tide configure"
    log "• In tmux: press Ctrl+a then Shift+I to install plugins"
    log "• Review and customize your dotfiles as needed"
    echo
    warn "Some changes may require a system restart to take effect."
}

# Export functions for use in subscripts
export -f log success error warn step prompt_to_continue read_package_list show_progress
