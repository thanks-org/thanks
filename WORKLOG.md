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
| B5-1..B5-10 — Phase 3 backend (10 endpoints): GET/PUT /me, /me/claims, /me/impact, /users/:id, /leaderboard, /messages list+thread+send, POST /claims/:id/ratings (claimParties.peerOf authz, in-TX rating_avg recompute, UNIQUE→409 on duplicate, notification row written cho FCM I4-1 consume). Reassign từ Quang (B5-1..B5-6) + Hiếu (B5-10) sang TrungVT để unblock Frontend Phase 3. | TrungVT | 2026-04-28 | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B6-1..B6-7 — Phase 4 backend (7 endpoints): POST /auth/social (pluggable SocialVerifier per provider; dev mode accept base64-JSON id_token, production verifier để TODO chờ provider keys; find-or-create user qua auth_providers UNIQUE), GET/POST/PUT /me/businesses + /businesses/:id, GET/POST/PUT /me/organizations + /organizations/:id (owner check → 403, status mặc định pending_review). **Lưu ý**: social-only user nhận synthetic phone `@<14 hex>` (ẩn khỏi response) vì cột `phone` NOT NULL — sẽ thay khi user link OTP thật. Reassign từ Quang (B6-2..B6-7) + Hiếu (B6-1) sang TrungVT để unblock Frontend Phase 4. | TrungVT | 2026-04-28 | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705) |
| B3-1, B3-2 — `POST /posts/:id/claims` + `DELETE /claims/:id`: TX `SELECT ... FOR UPDATE` trên posts row → check status='active', user_id != caller, quantity → INSERT claim (4-digit pickup code via crypto/rand) + UPDATE quantity_remaining + INSERT notification (type='claim_created') tất cả trong 1 TX. Cancel: receiver-only, FOR UPDATE trên claim row, atomic restore quantity_remaining. Sentinels: post_not_found/404, post_not_claimable/422, self_claim/403, insufficient_quantity/422, already_claimed/409 (UNIQUE post_id+user_id), claim_not_found/404, forbidden/403, claim_not_cancellable/409. 10-step smoke đã pass (claim → 6668 pickup code, self-claim → 403, duplicate → 409, qty 2→1, cancel → 204 + qty 1→2, double-cancel → 409). Reassign từ Hiếu sang TrungVT để unblock Frontend Luân (F1-7 Claim Confirmed). | TrungVT | 2026-04-28 | [9313e58](https://github.com/thanks-org/thanks-backend/commit/9313e58) |
| B6-1 production Google id_token verifier — replaced placeholder trong `internal/social/verifier.go` bằng tokeninfo-endpoint impl (stdlib only, không thêm dep). Validate `aud == GOOGLE_CLIENT_ID`, `iss ∈ {accounts.google.com, https://accounts.google.com}`, `exp`, non-empty `sub`. Dev mode (JWT_SECRET=dev default) vẫn short-circuit để Luân test app không cần cấu hình thêm. Google Cloud Web Client ID `650801838642-...` đã tạo (project name: "Thanks"). Wire env passthrough trong `thanks-infra/docker-compose.yml` ([8827984](https://github.com/thanks-org/thanks-infra/commit/8827984)). Còn lại Zalo/Facebook/Apple verifiers vẫn TODO chờ ops set up provider keys. | TrungVT | 2026-04-28 | [26c7533](https://github.com/thanks-org/thanks-backend/commit/26c7533) |
