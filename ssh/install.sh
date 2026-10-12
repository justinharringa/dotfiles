#!/bin/sh
# Link ~/.ssh/config to the tracked config and set up 1Password's SSH agent
# socket link. Per-machine hosts go in ~/.ssh/config.local (untracked).
# This is run automatically by script/install

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="${SCRIPT_DIR}/config"
CONFIG_DST="${HOME}/.ssh/config"
OP_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
OP_LINK="${HOME}/.1password/agent.sock"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

# --- ~/.ssh/config symlink ---------------------------------------------------
if [ -L "$CONFIG_DST" ] && [ "$(readlink "$CONFIG_DST")" = "$CONFIG_SRC" ]; then
  echo "  ssh config already symlinked"
elif [ -e "$CONFIG_DST" ] && [ ! -L "$CONFIG_DST" ]; then
  echo "  Skipping ssh config: ${CONFIG_DST} exists and is not a symlink."
  echo "  Move its host entries to ~/.ssh/config.local, delete it, and re-run."
else
  ln -sf "$CONFIG_SRC" "$CONFIG_DST"
  echo "  Linked ssh config: ${CONFIG_DST} -> ${CONFIG_SRC}"
fi

# --- 1Password SSH agent socket ----------------------------------------------
# The short path 1Password's docs recommend; hosts in config.local point
# IdentityAgent at it. The target only exists once 1Password's SSH agent is on
# (Settings -> Developer); the link is harmless until then.
mkdir -p "${HOME}/.1password"
if [ -L "$OP_LINK" ] && [ "$(readlink "$OP_LINK")" = "$OP_SOCK" ]; then
  echo "  1Password agent socket already linked"
else
  ln -sfn "$OP_SOCK" "$OP_LINK"
  echo "  Linked 1Password agent socket: ${OP_LINK}"
fi
