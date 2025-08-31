#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eE

export PATH="$HOME/.local/share/craftymac/bin:$PATH"
SETUP_INSTALL=~/.local/share/craftymac/install

# Load core libraries
source ~/.local/share/craftymac/lib/core.sh

# Preflight checks
source $SETUP_INSTALL/preflight/show-env.sh
source $SETUP_INSTALL/preflight/trap-errors.sh

# Packaging (in dependency order)
source $SETUP_INSTALL/packaging/homebrew.sh
source $SETUP_INSTALL/packaging/cli-tools.sh

# Cleanup and completion
cleanup_installation
show_completion_message
