#!/bin/bash

GRAY='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPOS=("." "thanks-backend" "thanks-app" "thanks-infra")
NAMES=("thanks (root)" "thanks-backend" "thanks-app" "thanks-infra")

echo ""

# ── Git ──────────────────────────────────────────────────────────────
for i in "${!REPOS[@]}"; do
  repo="$DIR/${REPOS[$i]}"
  name="${NAMES[$i]}"

  [ ! -d "$repo/.git" ] && continue

  ahead=$(git -C "$repo" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  changed=$(git -C "$repo" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  if [ "$ahead" -gt 0 ] || [ "$changed" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠${NC}   $name"
    [ "$ahead"   -gt 0 ] && echo -e "       ${YELLOW}↑ $ahead commit(s) unpushed${NC}"
    [ "$changed" -gt 0 ] && echo -e "       ${GRAY}~ $changed file(s) uncommitted${NC}"
  else
    echo -e "  ${GREEN}✓${NC}  $name — clean"
  fi
done

echo ""

# ── Tasks ─────────────────────────────────────────────────────────────
TASKS="$DIR/TASKS.md"
if [ -f "$TASKS" ]; then
  # Chỉ đếm task rows (bắt đầu bằng "| B / F / I + số"), bỏ header & separator
  task_rows=$(grep -E "^\| [A-Z]" "$TASKS")

  in_progress=$(echo "$task_rows" | grep -c "\[~\]")
  todo=$(echo        "$task_rows" | grep -c "\[ \]")
  done_count=$(echo  "$task_rows" | grep -c "\[x\]")

  if [ "$in_progress" -gt 0 ]; then
    echo -e "  ${CYAN}◎${NC}  Tasks: ${YELLOW}$in_progress đang làm${NC} · ${GRAY}$todo chưa làm${NC} · ${GREEN}$done_count xong${NC}"
  else
    echo -e "  ${CYAN}◎${NC}  Tasks: ${GRAY}$todo chưa làm${NC} · ${GREEN}$done_count xong${NC}"
  fi
fi

# ── Screens ───────────────────────────────────────────────────────────
SCREENS_DIR="$DIR/idea_to_static_html"
APP_FEATURES="$DIR/thanks-app/lib/features"

if [ -d "$SCREENS_DIR" ] && [ -d "$APP_FEATURES" ]; then
  total=$(find "$SCREENS_DIR" -name "*.html" | wc -l | tr -d ' ')
  done_screens=$(find "$APP_FEATURES" -name "*_screen.dart" | wc -l | tr -d ' ')
  remaining=$((total - done_screens))

  if [ "$remaining" -le 0 ]; then
    echo -e "  ${GREEN}◎${NC}  Screens: ${GREEN}$done_screens/$total done${NC}"
  else
    echo -e "  ${CYAN}◎${NC}  Screens: ${GREEN}$done_screens/$total done${NC} · ${GRAY}$remaining chưa làm${NC}"
  fi
fi

echo ""
