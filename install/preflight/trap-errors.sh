#!/bin/bash

# Error catching with context
catch_errors() {
    local exit_code=$?
    local line_number=$1

    echo -e "\n${RED}❌ Setup failed!${NC}"
    echo
    echo -e "${YELLOW}Error Details:${NC}"
    echo "  Exit Code: $exit_code"
    echo "  Line: $line_number"
    echo "  Command: $BASH_COMMAND"
    echo "  Script: ${BASH_SOURCE[2]}"
    echo
    echo -e "${CYAN}Troubleshooting:${NC}"
    echo "  • Check your internet connection"
    echo "  • Verify you have admin privileges"
    echo "  • Try running: brew doctor"
    echo "  • Check available disk space"
    echo
    echo -e "${BLUE}Get Help:${NC}"
    echo "  • GitHub Issues: https://github.com/craftyshelf/craftymac/issues"
    echo "  • Retry: bash ~/.local/share/craftymac/install.sh"
    echo

    exit $exit_code
}


trap 'catch_errors $LINENO' ERR
