#!/usr/bin/env zsh
# Claude Code statusline script
# Shows: git branch & status | model | context usage | session duration | time

input=$(cat)

# Extract JSON fields
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
used_tokens=$(echo "$input" | jq -r '.context_window.used_tokens // 0')
total_tokens=$(echo "$input" | jq -r '.context_window.total_tokens // 0')
duration_sec=$(echo "$input" | jq -r '.session.duration_seconds // 0')

# Git branch and status
branch=$(git -c core.filesRefLockTimeout=0 rev-parse --abbrev-ref HEAD 2>/dev/null || echo '(no git)')
git_status=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  # Check for uncommitted changes
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    git_status="*"
  fi
  # Check ahead/behind remote
  ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
  if [ $ahead -gt 0 ]; then git_status="${git_status}↑${ahead}"; fi
  if [ $behind -gt 0 ]; then git_status="${git_status}↓${behind}"; fi
  # Check if in a worktree
  if git rev-parse --git-common-dir 2>/dev/null | grep -q "worktrees"; then
    git_status="${git_status}[WT]"
  fi
fi

# Context window usage bar
context_bar=""
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  filled=$((used_int / 5))
  empty=$((20 - filled))
  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done

  # Format tokens as K
  used_k=$((used_tokens / 1000))
  total_k=$((total_tokens / 1000))

  context_bar=" | ctx: [${bar}] ${used_int}% (${used_k}K/${total_k}K)"
fi

# Session duration
duration=""
if [ $duration_sec -gt 0 ]; then
  hours=$((duration_sec / 3600))
  mins=$(((duration_sec % 3600) / 60))
  if [ $hours -gt 0 ]; then
    duration=" | ⏱ ${hours}h${mins}m"
  elif [ $mins -gt 0 ]; then
    duration=" | ⏱ ${mins}m"
  fi
fi

# Current time
timestamp=$(date +"%H:%M")

# Assemble the statusline
echo "git:${branch}${git_status} | ${model}${context_bar}${duration} | ${timestamp}"
