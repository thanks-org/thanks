#!/bin/bash
set -e

GRAY='\033[0;37m'
GREEN='\033[0;32m'
NC='\033[0m'

REPOS=("thanks-backend" "thanks-app" "thanks-infra")

echo ""
for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    echo -e "  ${GRAY}↻${NC}  $repo..."
    git -C "$repo" pull --quiet
  else
    echo -e "  ${GRAY}–${NC}  $repo not found, skipping"
  fi
done
echo -e "  ${GREEN}✓${NC}  Done"
echo ""
