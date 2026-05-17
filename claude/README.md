# claude

Helpers for running [Claude Code](https://claude.com/claude-code) inside tmux,
with each topic isolated in its own git worktree.

`aliases.zsh` auto-loads via the dotfiles topic loader — nothing to wire up.

## Aliases

| Alias  | Function             | What it does                                              |
|--------|----------------------|-----------------------------------------------------------|
| `clc`  | `claude-tmux`        | New (or attached) tmux **session** running `claude`.      |
| `clcw` | `claude-tmux-window` | New full-screen **window** running `claude` in the current session. |
| `clcp` | `claude-tmux-pane`   | New **pane** running `claude` in the current window, re-tiled evenly. |

All three accept an optional topic `name` and a `--no-worktree` / `-n` flag.

```sh
clc                  # session/worktree named after the repo (or cwd)
clc reassembly       # session/worktree named "reassembly"
clcw review          # extra window in the current session for a "review" topic
clcp                 # extra tiled pane, alongside the current Claude
clc --no-worktree x  # named session in the current dir, no worktree
```

`clcw` and `clcp` must be run from inside tmux; if not, they tell you to use
`clc` instead.

## Worktrees

When the current directory is a git repo, the helpers create (or reuse) a
worktree so concurrent Claude sessions never clobber each other's edits:

- **Location:** `$CLAUDE_WORKTREE_ROOT/<repo>/<name>`
  (default `~/ws/.worktrees/<repo>/<name>` — override in `~/.localrc`).
- **Branch:** `claude/<name>`. Reused if it already exists; otherwise created
  from the current `HEAD`.
- **`name`** defaults to the repo name, so bare `clc` reuses one worktree per
  repo. Pass a name to get a separate worktree per topic.

Outside a git repo, or with `--no-worktree`, the helpers just use the current
directory.

Clean up finished worktrees with:

```sh
git worktree remove ~/ws/.worktrees/<repo>/<name>
git branch -d claude/<name>
```

## Layout notes

tmux does not auto-fit panes — each split halves the current pane. `clcp`
applies the `tiled` layout after every split so panes stay an even grid.
`tiled` is comfortable up to ~4 Claudes on a normal display; beyond that,
prefer `clcw` (full-screen windows, switch with `Ctrl-b n` / `p`).
