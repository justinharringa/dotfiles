#!/bin/sh
# Symlink the Ghostty config into ~/.config/ghostty.
# This is run automatically by script/install.
#
# Ghostty's config lives at ~/.config/ghostty/config, which the *.symlink
# convention (mapping to ~/.<name>) can't target, so we link it here.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="${SCRIPT_DIR}/config"
CONFIG_DST="${HOME}/.config/ghostty/config"

mkdir -p "${HOME}/.config/ghostty"

if [ -L "$CONFIG_DST" ] && [ "$(readlink "$CONFIG_DST")" = "$CONFIG_SRC" ]; then
  echo "  Ghostty config already symlinked"
elif [ -e "$CONFIG_DST" ] && [ ! -L "$CONFIG_DST" ]; then
  mv "$CONFIG_DST" "${CONFIG_DST}.backup"
  echo "  Backed up existing Ghostty config to ${CONFIG_DST}.backup"
  ln -s "$CONFIG_SRC" "$CONFIG_DST"
  echo "  Linked Ghostty config: ${CONFIG_DST} -> ${CONFIG_SRC}"
else
  ln -sf "$CONFIG_SRC" "$CONFIG_DST"
  echo "  Linked Ghostty config: ${CONFIG_DST} -> ${CONFIG_SRC}"
fi
