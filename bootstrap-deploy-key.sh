#!/bin/bash
#
# Generate ed25519 SSH deploy key and encrypt with SOPS.
# Private key never touches disk unencrypted after this.
#
# Usage: ./bootstrap-deploy-key.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENCRYPTED_KEY="$SCRIPT_DIR/deploy-key.sops"
PUBLIC_KEY_FILE="$SCRIPT_DIR/deploy-key.pub"
SOPS_KEYSERVICE="tcp://100.77.42.49:5000"
SOPS_AGE_KEY="age1tpm1qtdhls43j4azm6m22s4nhe9rgnevru75zpfau7qjj8cxnrezec367nlatuy"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }
info() { echo -e "${GREEN}[INFO]${NC} $1" >&2; }

command -v sops &>/dev/null || error "sops not installed"

[[ -f "$ENCRYPTED_KEY" ]] && error "deploy-key.sops already exists. Delete it to regenerate."

# Generate in /dev/shm (RAM) if available
if [[ -d /dev/shm ]]; then
    TMP=$(mktemp -d /dev/shm/ssh.XXXXXX)
else
    TMP=$(mktemp -d)
fi
trap "shred -u $TMP/* 2>/dev/null; rm -rf $TMP" EXIT

info "Generating ed25519 key..."
ssh-keygen -t ed25519 -C "cowboycuban-deploy" -f "$TMP/key" -N "" -q

# Save public key (this one is fine to store)
cp "$TMP/key.pub" "$PUBLIC_KEY_FILE"

# Encrypt private key directly
info "Encrypting private key..."
sops encrypt --keyservice "$SOPS_KEYSERVICE" --age "$SOPS_AGE_KEY" "$TMP/key" > "$ENCRYPTED_KEY" || {
    error "SOPS encryption failed. Is Tailscale connected?"
}

info "Done!"
echo ""
echo -e "${GREEN}PUBLIC KEY (add to GitHub as deploy key with write access):${NC}"
cat "$PUBLIC_KEY_FILE"
echo ""
echo "Files created:"
echo "  $PUBLIC_KEY_FILE  (commit this)"
echo "  $ENCRYPTED_KEY    (commit this)"
echo ""
echo "Usage: ./git-deploy.sh push origin main"
