#!/bin/sh
# Install Claude Code statusline configuration and shared keybindings
# This is run automatically by script/install

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATUSLINE_SCRIPT="${SCRIPT_DIR}/statusline.sh"
SETTINGS_FILE="${HOME}/.claude/settings.json"
KEYBINDINGS_SRC="${SCRIPT_DIR}/keybindings.json"
KEYBINDINGS_DST="${HOME}/.claude/keybindings.json"

# --- Keybindings symlink ---------------------------------------------------
mkdir -p "${HOME}/.claude"
if [ -L "$KEYBINDINGS_DST" ] && [ "$(readlink "$KEYBINDINGS_DST")" = "$KEYBINDINGS_SRC" ]; then
  echo "  Claude keybindings already symlinked"
elif [ -e "$KEYBINDINGS_DST" ] && [ ! -L "$KEYBINDINGS_DST" ]; then
  echo "  Skipping keybindings: ${KEYBINDINGS_DST} exists and is not a symlink (manual file)"
else
  ln -sf "$KEYBINDINGS_SRC" "$KEYBINDINGS_DST"
  echo "  Linked Claude keybindings: ${KEYBINDINGS_DST} -> ${KEYBINDINGS_SRC}"
fi

# Ensure statusline script is executable
chmod +x "$STATUSLINE_SCRIPT"

# Check if settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "  Skipping Claude statusline: ${SETTINGS_FILE} does not exist"
  exit 0
fi

# Check if statusLine already points to our script
current_command=$(jq -r '.statusLine.command // empty' "$SETTINGS_FILE")
if [ "$current_command" = "$STATUSLINE_SCRIPT" ]; then
  echo "  Claude statusline already configured"
  exit 0
fi

# Backup settings.json
cp "$SETTINGS_FILE" "${SETTINGS_FILE}.bak"
echo "  Backed up ${SETTINGS_FILE}"

# Update settings.json to use our script
jq --arg script "$STATUSLINE_SCRIPT" \
  '.statusLine = {"type": "command", "command": $script}' \
  "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp"

mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

echo "  Installed Claude statusline: ${STATUSLINE_SCRIPT}"
echo "  (Restart Claude Code for changes to take effect)"
