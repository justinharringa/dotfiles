# Spawn Claude Code inside tmux. When the cwd is a git repo, work happens in a
# dedicated git worktree so each session is isolated from your main checkout.
#
#   clc  [name]   new/attached tmux SESSION running claude   (one per topic)
#   clcw [name]   new WINDOW running claude in the current session (full-screen)
#   clcp [name]   new tiled PANE running claude in the current window
#
# Flags (all three): --no-worktree | -n   reuse the current dir, no worktree.

# Where worktrees live. Override in ~/.localrc if you prefer.
: ${CLAUDE_WORKTREE_ROOT:=$HOME/ws/.worktrees}

# Resolve the topic name + working directory for a Claude session.
# Prints "<name>\t<dir>" on stdout; diagnostics go to stderr.
# Creates (or reuses) a git worktree unless $1 is "1" (no-worktree).
_claude_session_target() {
  emulate -L zsh
  local no_worktree="$1" name="$2"
  local start_dir="$PWD" repo_root

  if (( ! no_worktree )) && repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    local repo_name=${repo_root:t}
    name=${name:-$repo_name}
    local branch="claude/${name}"
    local worktree_dir="${CLAUDE_WORKTREE_ROOT}/${repo_name}/${name}"

    if [[ -d "$worktree_dir" ]]; then
      print -u2 "claude: reusing worktree $worktree_dir"
    else
      print -u2 "claude: creating worktree $worktree_dir (branch $branch)"
      mkdir -p "${worktree_dir:h}"
      if git -C "$repo_root" show-ref --verify --quiet "refs/heads/${branch}"; then
        git -C "$repo_root" worktree add "$worktree_dir" "$branch" >&2 || return 1
      else
        git -C "$repo_root" worktree add -b "$branch" "$worktree_dir" >&2 || return 1
      fi
    fi
    start_dir="$worktree_dir"
  else
    name=${name:-${PWD:t}}
  fi

  print -r -- "${name}"$'\t'"${start_dir}"
}

# Shared option parser. Sets `no_worktree` and leaves the name in $REPLY.
# Usage: _claude_parse_opts <cmd-name> "$@"  || return $?
_claude_parse_opts() {
  emulate -L zsh
  local cmd="$1"; shift
  no_worktree=0
  while [[ "$1" == -* ]]; do
    case "$1" in
      -n|--no-worktree) no_worktree=1 ;;
      -h|--help) print "usage: $cmd [--no-worktree] [name]"; return 2 ;;
      *) print -u2 "$cmd: unknown option: $1"; return 1 ;;
    esac
    shift
  done
  REPLY="$1"
}

# clc — new or attached tmux session running claude (one session per topic).
claude-tmux() {
  emulate -L zsh
  local no_worktree REPLY
  _claude_parse_opts claude-tmux "$@"; case $? in 1) return 1 ;; 2) return 0 ;; esac

  local target
  target=$(_claude_session_target "$no_worktree" "$REPLY") || return 1
  local name=${target%%$'\t'*} start_dir=${target#*$'\t'}
  local session=${name//[.:]/-}

  if ! tmux has-session -t "=$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$start_dir" claude
  fi
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "=$session"
  else
    tmux attach-session -t "=$session"
  fi
}

# clcw — new full-screen window running claude in the current tmux session.
claude-tmux-window() {
  emulate -L zsh
  if [[ -z "$TMUX" ]]; then
    print -u2 "claude-tmux-window: not inside a tmux session — use 'clc' instead"
    return 1
  fi
  local no_worktree REPLY
  _claude_parse_opts claude-tmux-window "$@"; case $? in 1) return 1 ;; 2) return 0 ;; esac

  local target
  target=$(_claude_session_target "$no_worktree" "$REPLY") || return 1
  local name=${target%%$'\t'*} start_dir=${target#*$'\t'}

  tmux new-window -n "${name//[.:]/-}" -c "$start_dir" claude
}

# clcp — new pane running claude in the current window, re-tiled evenly.
claude-tmux-pane() {
  emulate -L zsh
  if [[ -z "$TMUX" ]]; then
    print -u2 "claude-tmux-pane: not inside a tmux session — use 'clc' instead"
    return 1
  fi
  local no_worktree REPLY
  _claude_parse_opts claude-tmux-pane "$@"; case $? in 1) return 1 ;; 2) return 0 ;; esac

  local target
  target=$(_claude_session_target "$no_worktree" "$REPLY") || return 1
  local start_dir=${target#*$'\t'}

  tmux split-window -c "$start_dir" claude
  tmux select-layout tiled
}

alias clc='claude-tmux'
alias clcw='claude-tmux-window'
alias clcp='claude-tmux-pane'
