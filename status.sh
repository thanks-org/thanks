#!/bin/bash

GRAY='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPOS=("." "thanks-backend" "thanks-app" "thanks-infra")
NAMES=("thanks (root)" "thanks-backend" "thanks-app" "thanks-infra")

echo ""
for i in "${!REPOS[@]}"; do
  repo="${REPOS[$i]}"
  name="${NAMES[$i]}"

  if [ ! -d "$repo/.git" ]; then
    continue
  fi

  ahead=$(git -C "$repo" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  changed=$(git -C "$repo" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  if [ "$ahead" -gt 0 ] || [ "$changed" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠${NC}   $name"
    [ "$ahead" -gt 0 ]   && echo -e "       ${YELLOW}↑ $ahead commit(s) unpushed${NC}"
    [ "$changed" -gt 0 ] && echo -e "       ${GRAY}~ $changed file(s) uncommitted${NC}"
  else
    echo -e "  ${GREEN}✓${NC}  $name — clean"
  fi
done
echo ""
