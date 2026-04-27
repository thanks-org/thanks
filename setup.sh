#!/bin/bash
set -e

GREEN='\033[0;32m'
GRAY='\033[0;37m'
NC='\033[0m'

BASE="https://github.com/thanks-org"
REPOS=("thanks-backend" "thanks-app" "thanks-infra")

echo ""
echo "  thanks! — project setup"
echo "  ─────────────────────────"
echo ""

for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    echo -e "  ${GRAY}↻${NC}  $repo already exists — pulling latest..."
    git -C "$repo" pull --quiet
  else
    echo -e "  ${GREEN}↓${NC}  Cloning $repo..."
    git clone --quiet "$BASE/$repo.git"
  fi
done

echo ""
echo -e "  ${GREEN}✓${NC}  All repos ready. See README.md for next steps."
echo ""
