# Spawn Claude Code inside a named tmux session.
# When the cwd is a git repo, work happens in a dedicated git worktree
# so the session is isolated from your main checkout.
#
#   clc                  # session/worktree named after the repo (or cwd)
#   clc reassembly       # session/worktree named "reassembly"
#   clc --no-worktree x  # named session, but reuse the current directory

# Where worktrees live. Override in ~/.localrc if you prefer.
: ${CLAUDE_WORKTREE_ROOT:=$HOME/ws/.worktrees}

claude-tmux() {
  emulate -L zsh

  local no_worktree=0
  while [[ "$1" == -* ]]; do
    case "$1" in
      -n|--no-worktree) no_worktree=1 ;;
      -h|--help)
        print "usage: claude-tmux [--no-worktree] [name]"
        return 0 ;;
      *) print -u2 "claude-tmux: unknown option: $1"; return 1 ;;
    esac
    shift
  done

  local name="$1"
  local start_dir="$PWD"
  local repo_root

  # Inside a git work tree: create (or reuse) a worktree for this topic.
  if (( ! no_worktree )) && repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    local repo_name=${repo_root:t}
    name=${name:-$repo_name}
    local branch="claude/${name}"
    local worktree_dir="${CLAUDE_WORKTREE_ROOT}/${repo_name}/${name}"

    if [[ -d "$worktree_dir" ]]; then
      print -u2 "claude-tmux: reusing worktree $worktree_dir"
    else
      print -u2 "claude-tmux: creating worktree $worktree_dir (branch $branch)"
      mkdir -p "${worktree_dir:h}"
      if git -C "$repo_root" show-ref --verify --quiet "refs/heads/${branch}"; then
        git -C "$repo_root" worktree add "$worktree_dir" "$branch" || return 1
      else
        git -C "$repo_root" worktree add -b "$branch" "$worktree_dir" || return 1
      fi
    fi
    start_dir="$worktree_dir"
  else
    name=${name:-${PWD:t}}
  fi

  # tmux session names cannot contain '.' or ':'.
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

alias clc='claude-tmux'
