#!/bin/bash

# NightVault - Secure Environment Restoration System
# Version: 1.0.0

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
NIGHTVAULT_VERSION="1.0.0"
NIGHTVAULT_HOME="${HOME}/.nightvault"
REMOTE_PATH="remote:nightvault"

# Security settings
ENCRYPT_BACKUPS=true
VERIFY_SIGNATURES=true
USE_GPG=true

# Initialize logging
init_logging() {
    mkdir -p "${NIGHTVAULT_HOME}/security/logs"
    NIGHTVAULT_LOG="${NIGHTVAULT_HOME}/security/logs/access.log"
    touch "$NIGHTVAULT_LOG"
    chmod 600 "$NIGHTVAULT_LOG"
}

# Check dependencies
check_dependencies() {
    local deps="rclone gpg curl zip"
    for dep in $deps; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}Error: $dep is required but not installed.${NC}"
            exit 1
        fi
    done
}

# Mount or sync cloud vault
sync_vault() {
    echo -e "${BLUE}Syncing NightVault from cloud...${NC}"
    rclone sync --progress --checksum "$REMOTE_PATH" "$NIGHTVAULT_HOME"
    verify_integrity || exit 1
}

# Create directory structure
create_structure() {
    local dirs=(
        "core/config/{bash,zsh,nvim,ssh}"
        "core/bin/{custom-scripts,local-binaries}"
        "core/security/{keys,certificates}"
        "data/tools/{recon,exploit,post}"
        "data/payloads/{shells,scripts,binaries}"
        "data/notes/{research,targets,techniques}"
        "backup/{daily,weekly,monthly}"
    )

    for dir in "${dirs[@]}"; do
        mkdir -p "${NIGHTVAULT_HOME}/${dir}"
    done
    chmod -R 750 "$NIGHTVAULT_HOME"
}

# Create symlinks
create_symlinks() {
    echo -e "${BLUE}Creating symlinks...${NC}"
    ln -sfn "${NIGHTVAULT_HOME}/core/config/bash/.bashrc" "${HOME}/.bashrc"
    ln -sfn "${NIGHTVAULT_HOME}/core/config/zsh/.zshrc" "${HOME}/.zshrc"
    ln -sfn "${NIGHTVAULT_HOME}/core/config/nvim" "${HOME}/.config/nvim"
    ln -sfn "${NIGHTVAULT_HOME}/data/tools" "${HOME}/tools"
    ln -sfn "${NIGHTVAULT_HOME}/data/payloads" "${HOME}/payloads"
    ln -sfn "${NIGHTVAULT_HOME}/data/notes" "${HOME}/notes"
    ln -sfn "${NIGHTVAULT_HOME}/core/bin/local-binaries" "${HOME}/.local/bin"
}

# Main execution
main() {
    echo -e "${BLUE}Initializing NightVault v${NIGHTVAULT_VERSION}...${NC}"
    
    check_dependencies
    init_logging
    create_structure
    sync_vault
    create_symlinks
    
    # Reload shell configuration
    source "${HOME}/.bashrc" 2>/dev/null || source "${HOME}/.zshrc" 2>/dev/null
    
    echo -e "${GREEN}NightVault environment restored successfully!${NC}"
}

# Execute main function
main "$@"
