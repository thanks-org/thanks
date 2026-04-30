#!/bin/bash
# Usage: ./setup.sh [dev|prod]   (default: dev)
set -e

ENV="${1:-dev}"
if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "  Usage: $0 [dev|prod]"
  exit 1
fi

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m'

BASE="https://github.com/thanks-org"
REPOS=("thanks-backend" "thanks-app" "thanks-infra")

echo ""
echo "  thanks! — setup  [env: $ENV]"
echo "  ──────────────────────────────"
echo ""

# ── 1. Git pull ────────────────────────────────────────────────────────────
for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    echo -e "  ${GRAY}↻${NC}  $repo — pulling latest..."
    git -C "$repo" pull --quiet
  else
    echo -e "  ${GREEN}↓${NC}  Cloning $repo..."
    git clone --quiet "$BASE/$repo.git"
  fi
done
echo ""

# ── 2. Docker Desktop ──────────────────────────────────────────────────────
if ! docker info &>/dev/null; then
  echo -e "  ${YELLOW}⚡${NC}  Starting Docker Desktop..."
  open -a "Docker Desktop"
  echo -n "     Waiting"
  until docker info &>/dev/null; do
    echo -n "."
    sleep 2
  done
  echo ""
fi
echo -e "  ${GREEN}✓${NC}  Docker running"
echo ""

# ── 3. Docker Compose ──────────────────────────────────────────────────────
echo -e "  ${GRAY}↻${NC}  Starting containers..."
docker compose -f thanks-infra/docker-compose.yml up -d --quiet-pull
echo -e "  ${GREEN}✓${NC}  Containers up"
echo ""

# ── 4. Wait for DB + migrations ────────────────────────────────────────────
echo -n "  Waiting for DB"
until docker exec thanks_db pg_isready -U thanks_user &>/dev/null; do
  echo -n "."
  sleep 1
done
echo ""
echo -e "  ${GREEN}✓${NC}  DB ready"

echo -e "  ${GRAY}↻${NC}  Running migrations..."
(cd thanks-backend && make migrate-up 2>/dev/null || true)
echo ""

# ── 5. Seed ────────────────────────────────────────────────────────────────
if [[ "$ENV" == "dev" ]]; then
  echo -e "  ${YELLOW}⚠${NC}   Dev seed — wiping existing data..."
  (cd thanks-backend && make seed-dev)
else
  echo -e "  ${GRAY}↻${NC}  Prod seed — reference data only..."
  (cd thanks-backend && make seed-prod)
fi
echo -e "  ${GREEN}✓${NC}  Seed done"
echo ""

# ── 6. iOS Simulator ───────────────────────────────────────────────────────
if ! xcrun simctl list devices booted 2>/dev/null | grep -q "Booted"; then
  echo -e "  ${GRAY}↻${NC}  Starting iOS Simulator..."
  open -a Simulator
  sleep 4
fi
echo -e "  ${GREEN}✓${NC}  Simulator ready"
echo ""

# ── 7. Flutter ────────────────────────────────────────────────────────────
echo -e "  ${GREEN}▶${NC}  Starting Flutter..."
echo ""
cd thanks-app && flutter run
