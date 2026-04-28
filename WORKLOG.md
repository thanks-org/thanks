# WORKLOG — Thanks Project

> **Mọi người (và mọi Claude Code session) đều phải đọc file này trước khi bắt đầu làm bất cứ việc gì.**  
> Mục đích: tránh 2 người làm trùng nhau, biết context của nhau để làm tiếp đúng chỗ.

---

## Cách dùng

**Trước khi bắt đầu:**
1. Đọc toàn bộ file này
2. Tìm task mình sẽ làm trong Backlog
3. Di chuyển task đó sang **In Progress**, điền tên + ngày

**Khi làm xong:**
1. Di chuyển task sang **Done**
2. Điền commit hash hoặc PR link
3. Commit file WORKLOG.md này lên repo `thanks`

---

## 🔄 In Progress

| Task | Ai làm | Bắt đầu | Ghi chú |
|------|--------|---------|---------|
| _(trống)_ | | | |

---

## 📋 Backlog

> **Backlog đầy đủ đã chuyển sang [`TASKS.md`](TASKS.md)** — chia theo phase, người phụ trách, và dependencies.
> File này chỉ track **In Progress** và **Done**.

---

## ✅ Done

| Task | Ai làm | Ngày xong | Commit / PR |
|------|--------|-----------|-------------|
| Go backend skeleton + DB migrations (users, posts, claims, messages, ratings) | Claude Code | 2026-04-27 | [c84fcab](https://github.com/thanks-org/thanks-backend/commit/c84fcab) |
| Docker Compose + PostgreSQL setup | Claude Code | 2026-04-27 | [b8d1a8d](https://github.com/thanks-org/thanks-infra/commit/b8d1a8d) |
| Flutter app skeleton + Home Feed screen (mock data) | Claude Code | 2026-04-27 | [865bba2](https://github.com/thanks-org/thanks-app/commit/865bba2) |
| Prototype → Screen descriptions (thanks_screens.md) | Claude Code | 2026-04-27 | trong repo `thanks` |
| Screen descriptions → API doc HTML (api_doc.html) | Claude Code | 2026-04-27 | [ad17d6c](https://github.com/thanks-org/thanks/commit/ad17d6c) |
| Tách 26 prototype screens → static HTML (idea_to_static_html/) | Claude Code | 2026-04-27 | [7d81d2e](https://github.com/thanks-org/thanks/commit/7d81d2e) |
| App icon — thanks! branding (cream, terracotta, Plus Jakarta Sans 800) | Claude Code | 2026-04-28 | [0f8fbf8](https://github.com/thanks-org/thanks-app/commit/0f8fbf8) |
| Dockerize backend — Dockerfile.dev + air hot-reload, migrate tự chạy khi `make up` | Claude Code | 2026-04-28 | [831b6a1](https://github.com/thanks-org/thanks-infra/commit/831b6a1) |
| Update README (thanks, thanks-infra, thanks-backend) phản ánh setup mới | Claude Code | 2026-04-28 | [3c3c006](https://github.com/thanks-org/thanks-infra/commit/3c3c006) |
| Tái cấu trúc docs → api_and_doc/ (API doc + DB schema diagram) | Claude Code | 2026-04-28 | [ad17d6c](https://github.com/thanks-org/thanks/commit/ad17d6c) |
| Home Feed rebuild — match prototype (màu sắc, layout, item cards, top givers, sort bar) | Claude Code | 2026-04-28 | [6893534](https://github.com/thanks-org/thanks-app/commit/6893534) |
| Fix item card overflow + đổi tên app thành "Thanks" | Claude Code | 2026-04-28 | [41503ce](https://github.com/thanks-org/thanks-app/commit/41503ce) |
| Schema extension v2 — bổ sung businesses, organizations, auth_providers, sessions, device_tokens, notifications, thanks, post_schedules + extend users/posts/claims/ratings/messages cho khớp 26 prototype screens | Claude Code (vanlang) | 2026-04-28 | [PR #3](https://github.com/thanks-org/thanks-backend/pull/3) |
| B2-1: `GET /api/v1/posts` — feed API (category filter, Haversine proximity, pagination) | Luân | 2026-04-28 | [d39d561](https://github.com/thanks-org/thanks-backend/commit/d39d561) |
| B2-2: `GET /api/v1/posts/:id` — post detail (description, address, giver profile card) | Luân | 2026-04-28 | [46578f4](https://github.com/thanks-org/thanks-backend/commit/46578f4) |
| B1-1 — JWT bearer middleware (`auth.NewIssuer`, `middleware.RequireAuth`, 11 unit tests; blocker cho toàn bộ B-* / F-* Phase 1-3) | TrungVT | 2026-04-28 | [cf01e25](https://github.com/thanks-org/thanks-backend/commit/cf01e25) |
| F1-1: API client (dio, interceptors, error types) + F1-5: Home Feed → real API | Luân | 2026-04-28 | [426fb6d](https://github.com/thanks-org/thanks-app/commit/426fb6d) |
| F1-6: Screen 2.4.1 — Item Detail (hero image, quantity bar, pickup info, giver card, sticky claim button via Scaffold.bottomNavigationBar) | Luân | 2026-04-28 | [4dd3490](https://github.com/thanks-org/thanks-app/commit/4dd3490) |
| B4-1 — `POST /uploads` (LocalStorage tạm; Storage interface để swap R2/S3 khi I1-1 xong; 10 MB cap, MIME whitelist, path-traversal hardened) | TrungVT | 2026-04-28 | [2a57a1c](https://github.com/thanks-org/thanks-backend/commit/2a57a1c) |
| B4-2..B4-6 — Phase 2 backend writer endpoints: POST /posts, PUT /posts/:id, DELETE /posts/:id, GET /posts/:id/claimants, GET /me/posts (owner checks, sentinel→HTTP error mapping, atomic image replacement, status filter) | TrungVT | 2026-04-28 | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) |
| B1-4 — `POST /auth/logout` — JWT denylist (revoked_tokens table, jti+exp keyed; middleware rejects revoked tokens with 401 token_revoked; idempotent insert) | TrungVT | 2026-04-28 | [20c376d](https://github.com/thanks-org/thanks-backend/commit/20c376d) |
| B6-1 — `POST /auth/social` (Google tokeninfo + Apple JWKS/RS256; migration phone nullable; kéo lên Phase 1) | Luân | 2026-04-28 | [fa67ab9](https://github.com/thanks-org/thanks-backend/commit/fa67ab9) |
