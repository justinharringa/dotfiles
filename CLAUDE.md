# Dotfiles

## Symlink convention
`script/bootstrap` links `**/*.symlink` files to `~/.<basename>` (maxdepth 2, flat only).
For nested targets like `~/.claude/keybindings.json`, store the file in the topic dir and add a symlink step to that topic's `install.sh` — see `claude/install.sh` for the pattern.

## Running installs
- `script/bootstrap` — full setup (symlinks + deps)
- `script/install` — runs all `*/install.sh` topic scripts

## Terminal
User runs Ghostty. Inside tmux, use Shift+Cmd+click to open URLs (Ghostty's native URL detection is bypassed by tmux's mouse capture otherwise).
