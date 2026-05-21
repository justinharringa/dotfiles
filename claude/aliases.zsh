# Spawn Claude Code inside tmux for focused work.
#
#   clc [name]    Start/attach tmux session with Claude (no worktree, simple)
#   clcw [name]   New tmux window with Claude in isolated worktree (for parallel work)
#
# The window approach gives you focus + awareness: each task is a window,
# and tmux notifies you when Claude outputs something in the background.

# Where worktrees live (only used by clcw). Override in ~/.localrc if you prefer.
: ${CLAUDE_WORKTREE_ROOT:=$HOME/ws/.worktrees}

# clc — Start or attach to a tmux session running Claude in the current directory.
# Simple workflow: one Claude session per repo, work in your normal checkout.
claude-tmux() {
  emulate -L zsh
  local session="${1:-${PWD:t}}"
  session=${session//[.:]/-}  # sanitize for tmux (dots/colons not allowed)

  if ! tmux has-session -t "=$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$PWD" claude
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "=$session"
  else
    tmux attach-session -t "=$session"
  fi
}

# clcw — Create a new tmux window with Claude in an isolated worktree.
# Use this when you want Claude working on a separate task in parallel.
# The worktree keeps changes isolated, and tmux alerts you when it's active.
claude-tmux-worktree() {
  emulate -L zsh
  if [[ -z "$TMUX" ]]; then
    print -u2 "clcw: not inside tmux — use 'clc' to start a session first"
    return 1
  fi

  local name="$1" repo_root
  if ! repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    print -u2 "clcw: not in a git repository"
    return 1
  fi

  local repo_name=${repo_root:t}
  # Strip leading dot from repo name to avoid branch name issues (claude/.dotfiles → claude/dotfiles)
  repo_name=${repo_name#.}
  name=${name:-$repo_name}

  local branch="claude/${name}"
  local worktree_dir="${CLAUDE_WORKTREE_ROOT}/${repo_name}/${name}"

  if [[ -d "$worktree_dir" ]]; then
    print -u2 "clcw: reusing worktree $worktree_dir"
  else
    print -u2 "clcw: creating worktree $worktree_dir (branch $branch)"
    mkdir -p "${worktree_dir:h}"
    if git -C "$repo_root" show-ref --verify --quiet "refs/heads/${branch}"; then
      git -C "$repo_root" worktree add "$worktree_dir" "$branch" >&2 || return 1
    else
      git -C "$repo_root" worktree add -b "$branch" "$worktree_dir" >&2 || return 1
    fi
  fi

  tmux new-window -n "${name//[.:]/-}" -c "$worktree_dir" claude
}

alias clc='claude-tmux'
alias clcw='claude-tmux-worktree'
