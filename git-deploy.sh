#!/bin/bash
#
# Git wrapper that loads SOPS-encrypted deploy key into ssh-agent.
# Private key is piped directly to ssh-add (never touches disk).
#
# Usage: ./git-deploy.sh <git-command> [args...]
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENCRYPTED_KEY="$SCRIPT_DIR/deploy-key.sops"
PUBLIC_KEY_FILE="$SCRIPT_DIR/deploy-key.pub"
SOPS_KEYSERVICE="tcp://100.77.42.49:5000"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }
info() { echo -e "${GREEN}[INFO]${NC} $1" >&2; }

[[ $# -gt 0 ]] || { echo "Usage: $0 <git-command> [args...]"; exit 1; }
[[ -f "$ENCRYPTED_KEY" ]] || error "No deploy-key.sops. Run ./bootstrap-deploy-key.sh first."

# Start ssh-agent if needed
ssh-add -l &>/dev/null || {
    if [[ $? -eq 2 ]]; then
        eval "$(ssh-agent -s)" >/dev/null
        info "Started ssh-agent"
    fi
}

# Check if key already loaded
FINGERPRINT=$(ssh-keygen -lf "$PUBLIC_KEY_FILE" 2>/dev/null | awk '{print $2}')
if ssh-add -l 2>/dev/null | grep -q "$FINGERPRINT"; then
    info "Deploy key already loaded"
else
    info "Loading deploy key..."
    sops decrypt --keyservice "$SOPS_KEYSERVICE" "$ENCRYPTED_KEY" 2>/dev/null | ssh-add - 2>/dev/null || {
        error "Failed to load key. Is Tailscale connected?"
    }
fi

cd "$SCRIPT_DIR"
exec git "$@"
