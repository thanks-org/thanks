# Thanks — Task Plan

> File này là **product backlog đầy đủ** — tất cả tasks cần làm để có bản app chạy được.
> Cập nhật khi task được nhận hoặc hoàn thành.
> **In-progress tracking (ai đang làm gì):** xem `WORKLOG.md`

---

## Team

| Người | Vai trò chính |
|-------|---------------|
| **Luân** | Lead backend + lead Flutter |
| **TrungVT** | Backend (auth, middleware, messages) |
| **Hiếu** | Backend (claims, ratings, social auth) |
| **Quang** | Backend (me, profiles, businesses, orgs) |
| **Đức** | Flutter (giver/receiver screens, UI) |
| **TrungCD** | Infra, CI/CD, deploy, storage |
| **Vũ** | Design, Figma |

---

## Trạng thái task

`[ ]` = chưa làm · `[~]` = đang làm · `[x]` = xong

---

## Phase 1 — Core Loop (MVP)
> Mục tiêu: user có thể đăng nhập → xem items → claim → nhận pickup code

### Backend — Phase 1

#### [B1] Auth module
| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B1-1 | JWT middleware (Bearer token guard cho protected routes) | TrungVT | [x] | [cf01e25](https://github.com/thanks-org/thanks-backend/commit/cf01e25) — `auth.NewIssuer`, `middleware.RequireAuth`, 11 unit tests |
| B1-2 | `POST /auth/otp/send` — gửi OTP qua SMS | Luân | [-] | ⏸ Deferred — làm social auth (B6-1) trước; cần ESMS/Twilio account |
| B1-3 | `POST /auth/otp/verify` — verify OTP, trả JWT, tạo user mới nếu chưa có | Luân | [-] | ⏸ Deferred — phụ thuộc B1-2 |
| B1-4 | `POST /auth/logout` — invalidate token (denylist) | TrungVT | [x] | [20c376d](https://github.com/thanks-org/thanks-backend/commit/20c376d) — migration `revoked_tokens` + middleware check + 204 logout |

#### [B2] Posts — browse & detail
| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B2-1 | `GET /posts` — feed có filter category, lat/lng proximity, pagination | Luân | [x] | Public endpoint, không cần auth |
| B2-2 | `GET /posts/:id` — post detail đầy đủ | Luân | [x] | Public endpoint |

#### [B3] Claims
| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B3-1 | `POST /posts/:id/claims` — tạo claim, sinh 4-digit pickup code, decrement quantity | TrungVT (reassigned từ Hiếu) | [x] | Done [9313e58](https://github.com/thanks-org/thanks-backend/commit/9313e58) — TX `FOR UPDATE` chống race, self-claim 403, duplicate 409, notification row written cho FCM I4-1 consume |
| B3-2 | `DELETE /claims/:id` — cancel claim, restore quantity | TrungVT (reassigned từ Hiếu) | [x] | Done [9313e58](https://github.com/thanks-org/thanks-backend/commit/9313e58) — receiver-only, atomic restore quantity_remaining, double-cancel 409 |

---

### Flutter — Phase 1

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F1-1 | API client setup (dio/http, base URL, token interceptor, error handling) | Luân | [x] | Làm trước tất cả F-tasks |
| F1-2 | Auth service (lưu/đọc JWT từ secure storage) | TrungVT (reassigned từ Luân) | [x] | Done [4a326cb](https://github.com/thanks-org/thanks-app/commit/4a326cb) — `AuthService` singleton + `flutter_secure_storage` (key `auth_jwt`) + dio `QueuedInterceptor` auto-attach Bearer token |
| F1-3 | Screen 2.1.5 — Profile Logged Out (entry point vào auth) | TrungVT (reassigned từ Luân) | [x] | Done [72ba948](https://github.com/thanks-org/thanks-app/commit/72ba948) — state-aware Profile branching theo `AuthService.isAuthenticated()`; logged-in stub có nút "Đăng xuất" để test flow |
| F1-4 | Screen 2.1.6 — Sign Up / Auth Method (phone + OTP flow) | TrungVT (reassigned từ Luân) | [~] | Partial [2ef6901](https://github.com/thanks-org/thanks-app/commit/2ef6901) — static layout + Google button thật (kDebugMode = fake id_token POST, !kDebugMode = "Coming soon"); phone+OTP và Zalo/FB/Apple disabled với "Coming soon" SnackBar. **Còn lại:** Phone+OTP wire khi B1-2/B1-3 ship; Google switch sang `google_sign_in` package khi Android/iOS Client ID có. |
| F1-5 | Home Feed → kết nối real API (thay mock data) | Luân | [x] | Phụ thuộc F1-1, B2-1 |
| F1-6 | Screen 2.4.1 — Item Detail | Luân | [x] | Phụ thuộc B2-2 |
| F1-7 | Screen 2.4.2 — Claim Confirmed (pickup code display) | TrungVT (reassigned từ Luân) | [x] | Done [6cfd266](https://github.com/thanks-org/thanks-app/commit/6cfd266) — `ClaimConfirmedScreen` match prototype, wired Item Detail claim button → `POST /posts/:id/claims` → push screen + Cancel claim với confirm dialog → `DELETE /claims/:id` |

---

### Infra — Phase 1

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| I1-1 | File storage setup (Cloudflare R2 hoặc AWS S3) | TrungCD | [ ] | Cần trước khi implement POST /uploads |
| I1-2 | CI/CD GitHub Actions — build + test khi push lên main | TrungCD | [ ] | |
| I1-3 | Staging server (Railway hoặc Fly.io) — auto-deploy từ main | TrungCD | [ ] | |

---

## Phase 2 — Giver Full Flow
> Mục tiêu: giver có thể đăng item, quản lý items, xem danh sách người đã claim

### Backend — Phase 2

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B4-1 | `POST /uploads` — upload file lên S3/R2, trả CDN URL | TrungVT | [x] | [2a57a1c](https://github.com/thanks-org/thanks-backend/commit/2a57a1c) — LocalStorage tạm; Storage interface trong `internal/storage` cho phép swap R2/S3 khi I1-1 xong mà không đổi handler. 10 MB cap, MIME whitelist (JPG/PNG/WebP/HEIC/PDF), path-traversal hardened |
| B4-2 | `POST /posts` — tạo post mới (cần image_urls từ B4-1) | TrungVT (reassign từ Luân) | [x] | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) — transaction insert + post_images, validate category vs DB CHECK |
| B4-3 | `PUT /posts/:id` — update post | TrungVT | [x] | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) — partial update với pointer fields, owner check, image set thay thế atomic; quantity KHÔNG updatable (cancel + tạo lại) |
| B4-4 | `DELETE /posts/:id` — cancel post, notify claimants | TrungVT | [x] | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) — set status='cancelled', idempotent, 409 nếu đã completed. Push notification cho claimants skip Phase 1 (chờ I4-1) |
| B4-5 | `GET /posts/:id/claimants` — list tất cả người đã claim | TrungVT (reassign từ Hiếu) | [x] | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) — owner-only, JOIN users, trả pickup_code |
| B4-6 | `GET /me/posts` — my items với filter status | TrungVT (reassign từ Quang) | [x] | [a73c055](https://github.com/thanks-org/thanks-backend/commit/a73c055) — query param `status` validate vs `AllowedPostStatuses`, reuse PostSummary với optional `status` field |
| B4-7 | `GET /me/posts?business_id=` — filter posts theo business | TrungVT | [x] | [790a602](https://github.com/thanks-org/thanks-backend/commit/790a602) — UUID validate (400), ownership check (403 nếu không own), WHERE p.business_id = $N. Smoke pass: own→200, other→403, bad UUID→400. |

### Flutter — Phase 2

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F2-1 | Upload service (chọn ảnh, upload lên R2/S3 qua POST /uploads) | ~~Luân~~ TrungVT | [x] | [81ff436](https://github.com/thanks-org/thanks-app/commit/81ff436) — image_picker dep + UploadService (multipart via dio FormData) |
| F2-2 | Screen 2.2.7 — Submit Item Step 1 (ảnh, title, description) | ~~Đức~~ TrungVT | [x] | [37d6331](https://github.com/thanks-org/thanks-app/commit/37d6331) — SubmitItemDraft model + Step 1 screen |
| F2-3 | Screen 2.2.8 — Submit Item Step 2 (category, quantity, pickup, location) | ~~Đức~~ TrungVT | [x] | [d65ee26](https://github.com/thanks-org/thanks-app/commit/d65ee26) — Step 2 + createPost API + Home FAB + ticker; **drift fix** [b82877f](https://github.com/thanks-org/thanks-backend/commit/b82877f)/[154b378](https://github.com/thanks-org/thanks-app/commit/154b378) align lat/lng + clothes/tech |
| F2-4 | Screen 2.2.3 — My Items Personal | ~~Đức~~ TrungVT | [x] | [841a70c](https://github.com/thanks-org/thanks-app/commit/841a70c) — status filter tabs, swipe-to-cancel, "Xem người claim" → F2-6 |
| F2-5 | Screen 2.2.4 — My Items Business | ~~Đức~~ TrungVT | [x] | [841a70c](https://github.com/thanks-org/thanks-app/commit/841a70c) — MyBusinessesScreen entry + per-business header. **Backend gap:** `GET /me/posts?business_id=` chưa filter (sends param for forward-compat). |
| F2-6 | Screen 2.4.3 — Who's Claimed (claimants list) | ~~Đức~~ TrungVT | [x] | [841a70c](https://github.com/thanks-org/thanks-app/commit/841a70c) — post header + claimants với pickup code + status chip |

---

## Phase 3 — Profile, Messages & Leaderboard

### Backend — Phase 3

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B5-1 | `GET /me` — full profile (stats, rating, identity list) | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-2 | `PUT /me` — update profile (name, avatar, bio) | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-3 | `GET /me/claims` — claim history | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-4 | `GET /me/impact` — stats + thank-you notes | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-5 | `GET /users/:id` — public profile (user/business/org) | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-6 | `GET /leaderboard` — top givers by city | TrungVT (reassign từ Quang) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-7 | `GET /messages` — list conversations | TrungVT | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-8 | `GET /messages/claims/:claim_id` — message thread | TrungVT | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) |
| B5-9 | `POST /messages/claims/:claim_id` — send message | TrungVT | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3); notification row đã ghi, FCM push chờ I4-1 |
| B5-10 | `POST /claims/:id/ratings` — rate sau khi pickup | TrungVT (reassign từ Hiếu) | [x] | [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3); in-TX rating_avg recompute, UNIQUE(claim_id, rater_id)→409 |
| B5-11 | Fix `avatar_url` thiếu trong repository SELECT | TrungVT | [x] | Đã có sẵn — verify khi làm B6-8: `repository/users.go:35,192` SELECT `avatar_url`; `repository/messages.go:103,209` SELECT `peer.avatar_url`; models đã có field. Stale gap report — có thể fix sẵn trong [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3) Phase 3. **No code change needed.** |
| B5-12 | Fix `bio` không trả về trong `GET /me` | TrungVT | [x] | Đã có sẵn — verify khi làm B6-8: `repository/users.go:35` SELECT `bio`, `model/profile.go:42` `MeResponse.Bio` field. Stale gap report — fix sẵn trong [ed382c3](https://github.com/thanks-org/thanks-backend/commit/ed382c3). **No code change needed.** |

### Flutter — Phase 3

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F3-1 | Screen 2.1.4a — Giver Profile (personal only) | ~~Đức~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — auto-switch personal↔business based on `listMyBusinesses()` result |
| F3-2 | Screen 2.1.4b — Giver Profile (with business) | ~~Đức~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — same screen, business section visible khi có businesses |
| F3-3 | Screen 2.1.4c — Receiver Profile | ~~Đức~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — `PublicProfileScreen` từ `/users/:id`; wired từ Who's Claimed claimant rows |
| F3-4 | Screen 2.1.4d — Settings | ~~Luân~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — avatar upload (image_picker→UploadService), `PUT /me`, sign-out, notif toggles local-state |
| F3-5 | Screen 2.2.9 — Thanks & Ratings (impact stats + notes) | ~~Đức~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — `GET /me/impact` + recent thanks list (always `[]` khi chưa có completed claims) |
| F3-6 | Screen 2.1.2 — Givers Leaderboard | ~~Đức~~ TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — top 3 podium + list, period tabs (week/month/all-time), tap row → F3-3 |
| F3-7 | Screen 2.1.3a — Messages Receiver view | TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — conversation list + thread (gộp với F3-8 vì share `GET /messages` endpoint) |
| F3-8 | Screen 2.1.3b — Messages Giver view | TrungVT | [x] | [42af304](https://github.com/thanks-org/thanks-app/commit/42af304) — same screen với rating dialog khi `claim_status='completed'` (`POST /claims/:id/ratings`) |

---

## Phase 4 — Business, Org & Social Auth

### Backend — Phase 4

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B6-1 | `POST /auth/social` — OAuth với Zalo/Google/Facebook/Apple | TrungVT (reassign từ Hiếu) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705); pluggable SocialVerifier, dev mode accept base64-JSON id_token, production verifier TODO chờ provider keys |
| B6-2 | `GET /me/businesses` | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705) |
| B6-3 | `POST /businesses` — đăng ký business (status: pending) | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705) |
| B6-4 | `PUT /businesses/:id` | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705); owner check 403 |
| B6-5 | `GET /me/organizations` | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705) |
| B6-6 | `POST /organizations` — đăng ký org (status: pending) | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705) |
| B6-7 | `PUT /organizations/:id` | TrungVT (reassign từ Quang) | [x] | [413d705](https://github.com/thanks-org/thanks-backend/commit/413d705); owner check 403 |
| B6-8 | `GET /businesses/:id` — public business detail endpoint | TrungVT | [x] | [790a602](https://github.com/thanks-org/thanks-backend/commit/790a602) — public route (no auth), 404 nếu not found. Mirror shape của items trong `GET /me/businesses`. |
| B6-9 | `GET /organizations/:id` — public organization detail endpoint | TrungVT | [x] | [790a602](https://github.com/thanks-org/thanks-backend/commit/790a602) — public route (no auth), 404 nếu not found. **`address_detail` deferred**: cột không tồn tại trong `organizations` schema (chỉ có `address`); api_doc.html sai. Cần migration mới `ALTER TABLE organizations ADD COLUMN address_detail TEXT` + update api_doc nếu thực sự cần field — riêng task. |

### Flutter — Phase 4

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F4-1 | Social login (Zalo SDK + Google Sign-In + FB + Apple) vào Auth screen | ~~Luân~~ TrungVT | [~] | Polish-only [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — informative "Coming soon" SnackBars cho Zalo/FB/Apple, success toast trên kDebugMode Google login. **Còn lại:** swap fake id_token sang `google_sign_in` package + Zalo SDK + FB Login + Apple Sign-In khi provider keys/Client IDs có (Android/iOS Google Client ID, Zalo Open API App ID, FB App ID+Secret, Apple Services ID). |
| F4-2 | Screen 2.2.1 — Giver Public Profile (business) | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `GiverPublicBusinessScreen`. **Backend gap:** caller phải pass `BusinessModel` vì `GET /users/:id` không embed businesses[] và chưa có public `GET /businesses/:id`. |
| F4-3 | Screen 2.2.2 — Giver Public Profile (personal) | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — reuse `PublicProfileScreen` (F3-3); layout prototype tương đương, không build duplicate. |
| F4-4 | Screen 2.2.5 — Manage Businesses | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `ManageBusinessesScreen` thay `MyBusinessesScreen` từ F2-5; verification status badges (approved/pending_review/rejected), edit → F4-5, "+ Thêm doanh nghiệp" CTA. |
| F4-5 | Screen 2.2.6 — Add Business | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `AddBusinessScreen` create/edit form (name, category chips, logo upload, address, phone, description, address_detail, city); `POST /businesses` on create, `PUT /businesses/:id` on edit. |
| F4-6 | Screen 2.3.1 — Receiver Public Profile (personal) | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — reuse `PublicProfileScreen` (F3-3); layout prototype tương đương. |
| F4-7 | Screen 2.3.2 — Receiver Public Profile (organization) | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `ReceiverPublicOrganizationScreen`. **Backend gap:** caller phải pass `OrganizationModel` vì chưa có public `GET /organizations/:id`. |
| F4-8 | Screen 2.3.3 — Manage Organizations | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `ManageOrganizationsScreen` mirror F4-4. |
| F4-9 | Screen 2.3.4 — Add Organization | ~~Đức~~ TrungVT | [x] | [112ae3a](https://github.com/thanks-org/thanks-app/commit/112ae3a) — `AddOrganizationScreen` mirror F4-5; `POST /organizations` / `PUT /organizations/:id`. |

### Infra — Phase 4

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| I4-1 | FCM push notification service (backend gửi, app nhận) | TrungCD | [ ] | Backend: B3-1, B5-9 dùng |
| I4-2 | Production infra planning (Railway tiếp hay migrate sang K8s) | TrungCD | [ ] | |

### Design — ongoing

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| D1 | Design system Figma (color tokens, typography, components) | Vũ | [ ] | |
| D2 | App store assets (icon variants, screenshots, store listing) | Vũ | [ ] | |
| D3 | Empty states, error states, loading skeletons cho các screens | Vũ | [ ] | |

---

## Phase 5 — Frontend Polish & Real Integration
> Mục tiêu: 26 screens đã có nhưng nhiều flow vẫn là `SnackBar("Coming soon")`. Phase này wire các stub vào API/SDK đã sẵn để app dùng được end-to-end.
> Audit gap: thực hiện 2026-04-29 sau khi dò 26 prototype HTML × Flutter screens — `WORKLOG.md` § 2026-04-29.

### Backend — Phase 5

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B7-1 | `GET /me/notifications` — list notifications cho user (paginated, filter unread) | TrungVT | [x] | Done [0615c43](https://github.com/thanks-org/thanks-backend/commit/0615c43): `model/notification.go` + `repository/notifications.go` + `handler/notifications.go`. Params `limit` (def 20, cap 50), `offset`, `unread_only`. Response: `{total, unread_count, notifications[]}`. **Schema note**: `notifications` table có `id, user_id, type, related_entity_id, title, body, is_read, created_at` — **KHÔNG có** `data` JSONB như api_doc giả định; api_doc cần update. |
| B7-2 | `GET /posts?q=...&sort=...` — search title/description + sort (distance/recent/expiring) | TrungVT | [x] | Done [0615c43](https://github.com/thanks-org/thanks-backend/commit/0615c43): `repository/posts.go` thêm `Q` + `Sort` vào `ListPostsParams`, ILIKE qua `(title \|\| ' ' \|\| COALESCE(description,''))` với `escapeLike` (escape `% _ \`). Sort values: `recent` / `expiring` / `distance`. Default: distance khi có lat/lng, else recent. `sort=distance` không lat/lng silent fallback `recent`. |
| B7-3 | `POST /me/notifications/:id/read` (hoặc bulk `POST /me/notifications/read`) — mark notification đã đọc | TrungVT | [x] | Done [0615c43](https://github.com/thanks-org/thanks-backend/commit/0615c43): bulk endpoint `POST /me/notifications/read` body `{"ids":[...]}` hoặc `{"all": true}`. Response `{updated:count}`. UPDATE filter `WHERE user_id=$1 AND id = ANY($2)` nên không cần auth-z thêm. |

### Flutter — Phase 5

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F5-1 | Wire **"Nhắn tin"** trong Claim Confirmed → `MessageThreadScreen` | TrungVT | [x] | Done [925cca4](https://github.com/thanks-org/thanks-app/commit/925cca4): `_GiverCard` build `Conversation` từ `ClaimResponse`+postId, push `MessageThreadScreen`. Peer.id để rỗng — JWT `sub` là source of truth cho bubble direction nên fallback ổn. |
| F5-2 | **"Chỉ đường"** Claim Confirmed → mở Maps qua `url_launcher` | TrungVT | [x] | Done [925cca4](https://github.com/thanks-org/thanks-app/commit/925cca4): try `geo:0,0?q=<encoded address>` → fallback `https://www.google.com/maps/search/?api=1&query=<encoded>`. ClaimResponse không có lat/lng nên dùng address string. |
| F5-3 | Item Detail **image carousel** (PageView + dot indicator) | TrungVT | [x] | Done [925cca4](https://github.com/thanks-org/thanks-app/commit/925cca4): `_HeroImage` Stateless→Stateful, `PageView.builder` qua `post.images[]`, dot indicator + counter pill `1/N`. |
| F5-4 | Pickup code **copy-to-clipboard** (long-press 4-digit code block) | TrungVT | [x] | Done [925cca4](https://github.com/thanks-org/thanks-app/commit/925cca4): `GestureDetector` onTap+onLongPress → `Clipboard.setData` + SnackBar "Đã sao chép mã". |
| F5-5 | **Notifications inbox** screen + bottom-nav badge thật | TrungVT | [x] | Done [c1873da](https://github.com/thanks-org/thanks-app/commit/c1873da): `NotificationsInboxScreen` pull-to-refresh + infinite scroll (limit 20), icon-by-type, unread left-dot + tint, relative time, markRead(all:true) on open, empty/error states. Bell icon in Home AppBar (ValueListenableBuilder on `unreadNotificationsNotifier`). |
| F5-6 | Search bar Home Feed wire vào API (`q` param) | TrungVT | [x] | Done [441678d](https://github.com/thanks-org/thanks-app/commit/441678d): TextField + 350ms debounce, X clear, inline spinner, empty state "Không tìm thấy '<query>'", reset pagination on query change. |
| F5-7 | **Pull-to-refresh + pagination** Home Feed | TrungVT | [x] | Done [4b1ebdb](https://github.com/thanks-org/thanks-app/commit/4b1ebdb): `RefreshIndicator` (terracotta) + `ScrollController` infinite scroll trigger 300px-from-bottom, append page-N (limit=20), stop khi API trả < limit, error row "Tải thêm thất bại — chạm để thử lại". |
| F5-8 | Empty / error / loading skeleton states chuẩn hóa toàn app | _unassigned_ | [ ] | Phối hợp với D3 (Vũ). Hiện đa phần là `CircularProgressIndicator` đơn giản. |
| F5-9 | Sort tabs Home Feed (Gần / Mới / Sắp hết / Đã đóng) wire backend | TrungVT | [x] | Done [441678d](https://github.com/thanks-org/thanks-app/commit/441678d): sort=distance|recent|expiring wire to API; "Đã đóng" keeps client-side behavior; "Gần" falls back to recent + shows disabled label when no location; all sort changes reset pagination. |
| F5-10 | Onboarding **role picker** (Receiver/Giver) ở Profile Logged Out (2.1.5) | _unassigned_ | [ ] | Hiện `sign_up_auth_method_screen.dart:128-168` hard-code "Người nhận"; cần chọn từ logged-out screen + pass intent vào sign-up. |
| F5-11 | Bottom-nav messages **badge thật** từ unread_count API | TrungVT | [x] | Done [c1873da](https://github.com/thanks-org/thanks-app/commit/c1873da): `MainScaffold` polls every 30s, sums `unread_count` across conversations (no total_unread field), badge 1-99 or "99+", no badge when 0, silent auth-failure fallback. |
| F5-12 | Pickup code **share** Claim Confirmed → `share_plus` dialog | TrungVT | [x] | Done [4b1ebdb](https://github.com/thanks-org/thanks-app/commit/4b1ebdb): `share_plus ^10.1.0` (resolved 10.1.4); `Share.share` với text VN gồm title + pickup code + (optional) pickup window/address; iPad fallback `sharePositionOrigin = screen center`. |

### Backend — Extra (Public Profile endpoints)

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B-extra-1 | `GET /users/:id/posts` — list posts by a user (public profile page, no auth) | TrungVT (sonnet exec) | [x] | Done [5a22e03](https://github.com/thanks-org/thanks-backend/commit/5a22e03) — keyset cursor pagination, status filter (default active+completed), `{items, next_cursor, total}` shape. |
| B-extra-2 | `GET /users/:id/ratings` — list ratings received by a user (public, no auth) | TrungVT (sonnet exec) | [x] | Done [5a22e03](https://github.com/thanks-org/thanks-backend/commit/5a22e03) — keyset cursor pagination, rater+post context joined, aggregate `summary {average, total}`. |

### Flutter — Extra (UX improvements)

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F-extra-1 | **Giver profile sections** — "Bài đăng đang tặng" + "Đánh giá gần đây" in `GiverPublicBusinessScreen` | TrungVT (sonnet exec) | [x] | Done [44ae6a4](https://github.com/thanks-org/thanks-app/commit/44ae6a4) — `UsersService` (`getUserPosts`/`getUserRatings`), `UserRating` model, parallel fetch in `initState`, skeleton/empty/error states per section, top-5 post rows + rating rows with star row + relative date. |
| F-extra-2 | **Bottom nav bar on all sub-screens** — `AppBottomNavBar` widget reused across all pushed screens (except auth + screens with existing bottom CTA bars) | TrungVT (sonnet exec) | [x] | Done [44ae6a4](https://github.com/thanks-org/thanks-app/commit/44ae6a4) — `lib/shared/app_bottom_nav_bar.dart`; added to: `GiverPublicBusinessScreen`, `ReceiverPublicOrganizationScreen`, `NotificationsInboxScreen`, `ClaimConfirmedScreen`, `WhoClaimedScreen`, `MyItemsPersonalScreen`, `MyBusinessesScreen`, `ManageOrganizationsScreen`, `SettingsScreen`, `PublicProfileScreen`, `ThanksRatingsScreen`. Skipped: screens with existing bottom CTA bars (`ItemDetailScreen` _ClaimBar, `SubmitItemStep1/2`, `MessageThreadScreen`, `ManageBusinessesScreen`, `MyItemsBusinessScreen`, `AddBusinessScreen`, `AddOrganizationScreen`). |

### Backend — Extra (Gaps từ audit 2026-04-30)

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B-new-1 | `POST /claims/:id/thanks` — gửi thank-you note sau pickup | Claude | [x] | [f313cd8](https://github.com/thanks-org/thanks-backend/commit/f313cd8) — validate picked_up + UNIQUE(claim_id,from_user_id), 409 duplicate, 422 not picked_up |
| B-new-2 | `GET /leaderboard` thêm `giver_type` + `period` filter | Claude | [x] | [8e3a5fb](https://github.com/thanks-org/thanks-backend/commit/8e3a5fb) — giver_type=personal\|business + period=week\|month\|all_time; city unchanged |
| B-new-3 | Migration: `ALTER TABLE organizations ADD COLUMN address_detail TEXT` | Luân | [x] | Done — trong `000006_invite_model_and_extras.up.sql`. api_doc updated (POST/PUT/GET orgs + public org detail). |
| B-new-4 | `PUT /me/notification-preferences` — persist push/email toggle | Claude | [x] | [bc2a184](https://github.com/thanks-org/thanks-backend/commit/bc2a184) — JSONB push_enabled/email_enabled; GET /me giờ trả notification_preferences |
| B-new-5 | Wire `POST /uploads` (B4-1) sang R2/S3 | TrungCD | [ ] | Phụ thuộc I1-1. Storage interface đã có trong `internal/storage` — chỉ cần swap implementation. |
| B-new-6 | `PATCH /claims/:id/no-show` — giver đánh dấu receiver no-show | Claude | [x] | [8e3a5fb](https://github.com/thanks-org/thanks-backend/commit/8e3a5fb) — giver-only, idempotent, restore quantity_remaining, notify receiver |
| B-new-7 | Emit notification row khi business/org bị rejected | _unassigned_ | [ ] | Scenario K-13. Backend không viết notification khi admin set status=rejected. Phụ thuộc: cần admin panel (gap G-05/H-05) để trigger đúng event. |
| B-new-8 | Migration: bảng `business_members`, `org_members`, `invites` | Luân | [x] | Done — `000006_invite_model_and_extras.up.sql`. Backfill owner/admin rows cho existing data. Indexes đầy đủ incl. partial index cho pending invites. |
| B-new-9 | `POST /businesses/:id/invites` — owner mời staff vào business | _unassigned_ | [ ] | Phụ thuộc B-new-8. Gửi invite row + notification. Scenario G-06. |
| B-new-10 | `POST /organizations/:id/invites` — admin mời member vào org | _unassigned_ | [ ] | Phụ thuộc B-new-8. Scenario H-06. |
| B-new-11 | `POST /invites/:token/accept` — invitee chấp nhận (business hoặc org) | _unassigned_ | [ ] | Phụ thuộc B-new-8. Tạo row trong `business_members` hoặc `org_members`. Scenario G-07/H-07. |
| B-new-12 | `DELETE /businesses/:id/members/:user_id` + `DELETE /organizations/:id/members/:user_id` | _unassigned_ | [ ] | Phụ thuộc B-new-8. Scenario G-08/H-08. |
| B-new-13 | `POST /organizations/:id/requests` — org đăng "cần nhận" loại đồ | _unassigned_ | [ ] | Tính năng mới (Journey 13, Scenario E-12). Phức tạp — ngoài MVP; track để không quên. |
| B-new-14 | `GET /businesses/:id/members` + `GET /organizations/:id/members` — list members với role | _unassigned_ | [ ] | Phụ thuộc B-new-8. Owner-only cho business, admin-only cho org. Response: `[{user_id, name, avatar_url, role, joined_at}]`. Cần cho F-new-4/5 hiển thị danh sách. Scenario G-09, H-09. |
| B-new-15 | `GET /me/invites` — pending invites · `POST /invites/:token/decline` — từ chối invite | _unassigned_ | [ ] | Phụ thuộc B-new-8. `GET /me/invites` trả invites đang pending cho user hiện tại (filter by invitee_contact = phone/email của user). `POST /invites/:token/decline` set status='declined'. Cần cho F-new-8. Scenario G-10, H-10. |
| B-new-16 | API doc update — thêm sections Business Members + Org Members + Invites + Thanks + No-show + Notif Prefs | Luân | [x] | Done — `api_and_doc/api_doc.html`. Thêm 11 endpoint sections mới + nav links + address_detail cho orgs + notification_preferences cho GET /me. |
| B-new-17 | **Role enforcement — backend guard cho claim + post endpoints** | Claude | [x] | [f313cd8](https://github.com/thanks-org/thanks-backend/commit/f313cd8) — CreateClaim requires role_type='receiver'; CreatePost requires 'giver'; NULL → 403 forbidden_role |
| B-new-18 | **Role onboarding endpoint** — extend `PUT /me` để set `role_type` lần đầu | Claude | [x] | [f313cd8](https://github.com/thanks-org/thanks-backend/commit/f313cd8) — 422 invalid_role nếu sai value; role immutable sau khi đã set (pre-check current role) |
| B-new-19 | **DB migration — drop `both` khỏi role_type CHECK constraint** | Claude | [x] | [f313cd8](https://github.com/thanks-org/thanks-backend/commit/f313cd8) — migration file 000007 đã đúng; AllowedRoleTypes loại bỏ 'both' |

### Flutter — Extra (Gaps từ audit 2026-04-30)

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F-new-1 | Screen 2.2.9 — "Send a note" button → `POST /claims/:id/thanks` | Claude | [x] | Placed in message thread when claimStatus='picked_up' + role='receiver': "Cảm ơn" button → emoji picker + message dialog → sendThanks API |
| F-new-2 | No-show button trong Who's Claimed → `PATCH /claims/:id/no-show` | Claude | [x] | Confirm dialog + markNoShow API; shown beside "Xác nhận nhận hàng" for confirmed claims |
| F-new-3 | Claim dưới danh nghĩa org — UI dropdown chọn org trong Item Detail (E-10) | _unassigned_ | [ ] | Schema ok (`claims.organization_id`). Cần hiện dropdown khi user là org member và org đã verified. |
| F-new-4 | Business member management screen (invite, list, remove) | _unassigned_ | [ ] | Phụ thuộc B-new-9/11/12/14. Scenario G-06→09. Entry: Manage Businesses → tap business → "Quản lý thành viên". UI: list members (avatar + tên + role badge "Chủ"/"Nhân viên" + ngày tham gia) + nút "Mời thành viên" (input email/phone → gọi B-new-9) + swipe-to-remove (owner-only, B-new-12). Owner không thể xoá chính mình. |
| F-new-5 | Org member management screen (invite, list, remove) | _unassigned_ | [ ] | Phụ thuộc B-new-10/11/12/14. Scenario H-06→09. Mirror F-new-4 nhưng role badge "Quản trị"/"Tình nguyện viên". Admin-only actions. |
| F-new-8 | Accept / Decline invite screen (notification → in-app flow) | _unassigned_ | [ ] | Phụ thuộc B-new-11/15. Scenario G-07/G-10/H-07/H-10. Khi nhận notification invite → tap → mở InviteDetailScreen: tên entity + role được mời + inviter + nút "Chấp nhận" / "Từ chối". Sau accept: entity xuất hiện trong Manage Businesses hoặc Manage Organizations của invitee. Cũng cần `GET /me/invites` để hiển thị nếu user mở app trực tiếp (không qua notification). |
| F-new-6 | "Similar items" section trong Item Detail khi hết slot / đã đóng (A-13) | _unassigned_ | [ ] | Dùng `GET /posts?category=X&limit=5`, lọc bỏ item hiện tại. Hiện screen chỉ disable Claim button mà không gợi ý. |
| F-new-7 | Re-post gợi ý sau khi item hết hạn — My Items + notification tap (K-15) | _unassigned_ | [ ] | Journey 10: nút "Đăng lại" từ expired item card, pre-fill Submit Item Step 1 từ dữ liệu item cũ. |
| F-new-9 | **Role gating UI — ẩn/disable actions theo role_type của user đang đăng nhập** | Claude | [x] | [eac35a9](https://github.com/thanks-org/thanks-app/commit/eac35a9) — roleTypeNotifier, FAB hidden for receiver, ClaimBar hidden for giver, profile sections gated | Phụ thuộc B-new-17. Đọc `role_type` từ `GET /me` response (lưu trong `AuthService`). Rules: (1) `role_type='giver'` → ẩn "Nhận" button ở Item Detail, ẩn tab "Đồ nhận" trong Profile, ẩn Messages thread từ phía receiver. (2) `role_type='receiver'` → ẩn FAB "Đăng đồ" ở Home Feed, ẩn "Đồ tôi đăng" trong Profile, ẩn tab Doanh nghiệp trong Profile. (3) `role_type=NULL` (new user chưa chọn) → block cả hai action, redirect tới F-new-10 onboarding. |
| F-new-10 | **Role onboarding screen** — màn hình chọn vai trò sau lần đăng nhập đầu tiên | Claude | [x] | [eac35a9](https://github.com/thanks-org/thanks-app/commit/eac35a9) — RoleSelectionScreen (2 cards, no skip), triggered after Google login if role_type=null | Phụ thuộc B-new-18 + F-new-9. Trigger: `AuthService` detect `role_type == null` sau login → push `RoleSelectionScreen` trước khi vào Home Feed. UI: 2 lựa chọn ngang nhau — "Tôi muốn cho đồ" (giver) và "Tôi muốn nhận đồ" (receiver). Không có option "Cả hai". Sau chọn → `PUT /me {role_type: ...}` → lưu vào AuthService → navigate Home. Không cho phép skip. Role là cố định sau khi chọn. |

### Deferred — Phase 5
> Block trên external dependencies, không vào sprint này.

| # | Task | Block bởi | Ghi chú |
|---|------|-----------|---------|
| D5-A | AI suggest description / category trong Submit Item | AI service / endpoint chưa có | Prototype có "Regenerate" button; có thể bỏ khỏi MVP |
| D5-B | Phone + OTP login wire | B1-2, B1-3 (Twilio/ESMS account) | F1-4 partial; phone button SnackBar "Coming soon" |
| D5-C | Zalo / Facebook / Apple Sign-in native SDK | Provider keys chưa có | Google đã chạy thật; 3 còn lại SnackBar |
| D5-D | Map widget thật trong Claim Confirmed (`google_maps_flutter`) | Maps API key + billing | Hiện gradient placeholder; F5-2 unblock "Chỉ đường" trước |

---

## Phase 6 — Journey Gaps (post-26-screens)
> Mục tiêu: lấp gaps phát hiện qua audit 14 user journeys (`user_journeys.md`, 2026-04-30).
> Mỗi task gắn với journey cụ thể để giữ context khi implement.
>
> **Đã có sẵn (không lặp ở đây):** `B-new-1` (thanks endpoint = Journey 1), `B-new-2` (leaderboard filters = Journey 2/7), `F-new-1` (thanks UI = Journey 1) — xem section "Backend/Flutter — Extra (Gaps từ audit 2026-04-30)" ở trên.

### Backend — Phase 6

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B8-1 | Invite model schema — migration `business_members`, `organization_members`, `member_invites` (status pending/accepted/declined/revoked, role enum owner/admin/staff/member, unique business_id+user_id) | _unassigned_ | [ ] | Journey 5, 6. Foundation cho B8-2..B8-6 + F6-1..F6-3. |
| B8-2 | `POST /businesses/:id/invites` — owner mời thành viên qua email/phone, sinh invite_token + notification | _unassigned_ | [ ] | Journey 5. Phụ thuộc B8-1. |
| B8-3 | `POST /invites/:token/accept` + `POST /invites/:token/decline` — invitee respond | _unassigned_ | [ ] | Journey 5, 6. Sau accept → insert business_members/organization_members row. |
| B8-4 | `GET /businesses/:id/members` + `DELETE /businesses/:id/members/:user_id` — list + remove members | _unassigned_ | [ ] | Journey 5. Owner-only. Same pattern cho organizations. |
| B8-5 | Authorization gate — extend B4-2 (`POST /posts`), B4-3, B4-4 để member với role staff+ post được dưới business identity | _unassigned_ | [ ] | Journey 5. Hiện chỉ owner_user_id check; cần OR membership check. |
| B8-6 | `POST /organizations/:id/invites` + accept/decline (mirror B8-2/B8-3 cho org) | _unassigned_ | [ ] | Journey 6. |
| B8-8 | `POST /claims/:id/no-show` — giver mark receiver no-show, restore quantity_remaining, decrement receiver rating | _unassigned_ | [ ] | Journey 9. Gap D-07/K-08. Owner-only, idempotent, status='no_show'. Notification cho receiver. |
| B8-10 | Claim under organization identity — extend B3-1 nhận `claim_as_org_id`, validate user là member của org, lưu `claimer_org_id` | _unassigned_ | [ ] | Journey 6. Gap E-10 backend. Phụ thuộc B8-1. |
| B8-11 | `GET /posts/:id/similar` — items cùng category trong bán kính 5km, exclude completed/cancelled | Claude | [x] | [f313cd8](https://github.com/thanks-org/thanks-backend/commit/f313cd8) — Haversine 5km, same category, active only, limit 5, public endpoint |
| B8-12 | `POST /requests` + `GET /requests` — org đăng request cần nhận đồ (category, quantity, deadline, reason) | _unassigned_ | [ ] | Journey 13. Tính năng mới — bảng `requests`, mirror posts shape. Org-only initially. |

### Flutter — Phase 6

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F6-1 | Screen Member Management — list members + invite form (email/phone + role) trong Manage Businesses + Organizations | _unassigned_ | [ ] | Journey 5, 6. Phụ thuộc B8-2/B8-4/B8-6. |
| F6-2 | Invite Inbox — incoming invites trong Notifications inbox với accept/decline buttons | _unassigned_ | [ ] | Journey 5, 6. Phụ thuộc B8-3. |
| F6-3 | Identity picker khi create post — dropdown chọn personal/business/managed-business để post under | _unassigned_ | [ ] | Journey 5. Phụ thuộc B8-5 + B6-2. |
| F6-5 | Mark no-show button — Who's Claimed (F2-6) thêm action "Đánh dấu không đến" với confirm dialog → `POST /claims/:id/no-show` | _unassigned_ | [ ] | Journey 9. Phụ thuộc B8-8. |
| F6-6 | Leaderboard filter UI — Givers screen (F3-6) thêm tabs "Tất cả/Cá nhân/Doanh nghiệp/Tổ chức" + period dropdown | _unassigned_ | [x] | Journey 2, 7. Phụ thuộc B-new-2. app [9796a5d](https://github.com/thanks-org/thanks-app/commit/9796a5d) |
| F6-7 | Claim-as-org picker — Item Detail (F1-6) "Nhận" button → bottom sheet chọn personal/managed-org identity | _unassigned_ | [ ] | Journey 6. Phụ thuộc B8-10. |
| F6-8 | "Similar items" carousel khi item hết hàng — Item Detail show 3-5 cards từ `GET /posts/:id/similar` | _unassigned_ | [ ] | Journey 11. Phụ thuộc B8-11. |
| F6-9 | Re-post suggestion — My Items Personal (F2-4) item đã expires hiện CTA "Đăng lại" với prefilled draft | _unassigned_ | [ ] | Journey 10. Frontend-only (không cần backend mới). |
| F6-10 | Org request screens — list requests (browse) + create request form (org admin) | _unassigned_ | [ ] | Journey 13. Phụ thuộc B8-12. |

### Infra / Admin — Phase 6

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| G6-1 | Admin panel cho business/org verification (approve/reject pending) | _unassigned_ | [ ] | Journey 4. Gap G-05. Hiện verify thủ công qua DB UPDATE. Có thể dùng Retool/Forest/in-house dashboard. |

---

## Phase 7 — Screen Coverage Gaps (audit 2026-04-30)
> Mục tiêu: lấp các màn hình/UI flows journeys cần nhưng 26 screens hiện tại không cover.
> Audit method: cross-check `idea_to_static_html/` × `user_journeys.md` × Flutter `lib/features/`.
>
> **Phát hiện schema sẵn nhưng chưa có endpoint/UI:** `claims.no_show_at` + status `no_show`/`picked_up`, `businesses.rejection_reason`, `organizations.rejection_reason`, `post_schedules` table — chỉ thiếu handler + Flutter.

### Backend — Phase 7

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| B9-1 | `POST /claims/:id/confirm-pickup` — giver verify pickup code → transition `confirmed/pending` → `picked_up`, set timestamp | Claude Code | [x] | [634fae0](https://github.com/thanks-org/thanks-backend/commit/634fae0) — owner check JOIN posts, wrong-code 422, notification to receiver |
| B9-2 | `POST /claims/:id/confirm` — giver xác nhận claim trước pickup (`pending` → `confirmed`) | Claude Code | [x] | [634fae0](https://github.com/thanks-org/thanks-backend/commit/634fae0) — owner check, notification to receiver |
| B9-3 | `POST /posts/:id/schedules` + cron worker — recurring post (daily/weekly), tự generate post mới mỗi chu kỳ | _unassigned_ | [ ] | Journey 2, 12. Bảng `post_schedules` đã có schema; thiếu CRUD endpoint + background worker. |
| B9-4 | `GET /users/:id` + `/me` expose `no_show_count` field — derive from `COUNT(claims WHERE status='no_show' AND user_id=:id)` | Claude Code | [x] | [87883ee](https://github.com/thanks-org/thanks-backend/commit/87883ee) — subquery trong GetPublicProfile + loadMeStats, 1 round-trip |
| B9-5 | `businesses` + `organizations` thêm `license_url` column + `POST /businesses` accept license upload | Claude | [x] | [bbb4921](https://github.com/thanks-org/thanks-backend/commit/bbb4921) — migration 000008; model+repo+request updated; POST+PUT accept license_url |
| B9-6 | `GET /organizations/:id/claims` — list tất cả claims do bất kỳ member nào trong org đã claim | Claude | [x] | [bbb4921](https://github.com/thanks-org/thanks-backend/commit/bbb4921) — member-only, JOIN org_members, limit 100, claimer+post summary |
| B9-7 | `GET /me/businesses/:id` + `/me/organizations/:id` expose `rejection_reason` field (đã có column) | Claude | [x] | [bc2a184](https://github.com/thanks-org/thanks-backend/commit/bc2a184) — new owner-only routes; rejection_reason đã có sẵn trong repo |

### Flutter — Phase 7

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F7-1 | **Pickup Confirmation Screen (Giver POV)** — giver nhập/scan 4-digit pickup code → `POST /claims/:id/confirm-pickup` → success state | Claude Code | [x] | [77a98f0](https://github.com/thanks-org/thanks-app/commit/77a98f0) — PickupConfirmationScreen mới: 4-digit input + paste support + success state |
| F7-2 | **Rating Composer Screen** — sau pickup completed, full-screen rating (1–5 sao + text) cho cả 2 phía | _unassigned_ | [ ] | Journey 1, 8. Hiện F3-8 chỉ có dialog nhỏ trong Messages; cần screen riêng đẹp hơn cho hai-way rating. `POST /claims/:id/ratings` (B5-10) đã có. |
| F7-3 | **Recurring schedule UI trong Submit Item Step 2** — toggle "Đăng lặp lại" + chu kỳ (mỗi ngày/tuần) + ngày kết thúc | _unassigned_ | [ ] | Journey 2, 12. Hiện chỉ có pickup days multi-select (1 lần). Phụ thuộc B9-3. |
| F7-4 | **Business license upload field trong Add Business (F4-5)** — file picker (PDF/JPG) cho giấy phép kinh doanh | _unassigned_ | [x] | Journey 4. Phụ thuộc B9-5. app [9796a5d](https://github.com/thanks-org/thanks-app/commit/9796a5d) |
| F7-5 | **Verification rejection feedback** — Manage Businesses/Organizations (F4-4/F4-8) row "rejected" hiện reason + CTA "Sửa và gửi lại" | _unassigned_ | [x] | Journey 4. Phụ thuộc B9-7. app [9796a5d](https://github.com/thanks-org/thanks-app/commit/9796a5d) |
| F7-6 | **Edit Post screen / Re-post from expired** — full edit form (mở rộng từ F6-9 CTA) prefilled từ post cũ → `PUT /posts/:id` hoặc `POST /posts` với draft | _unassigned_ | [ ] | Journey 10. F6-9 mới là CTA; cần screen edit thực tế. `PUT /posts/:id` (B4-3) đã có. |
| F7-7 | **No-show warning badge trên Receiver Public Profile (F3-3, F4-6)** — chip "⚠ X lần không đến" nếu `no_show_count > 0` | Claude Code | [x] | [6ac5db8](https://github.com/thanks-org/thanks-app/commit/6ac5db8) — PublicUserProfile.noShowCount, row terracotta trong _buildSectionCard |
| F7-8 | **Org Dashboard screen** — list claims do tất cả members trong org đã claim, filter status, group by member | _unassigned_ | [ ] | Journey 6. Truy cập từ Manage Organizations (F4-8) → tap org. Phụ thuộc B9-6. |
| F7-9 | **Wire notification toggles trong Settings (F3-4) vào `PUT /me/notification-preferences`** | Claude | [x] | NotificationPreferences added to UserProfile; toggles init from profile; immediate persist on change |
| F7-10 | **Confirm/Reject claim button trong Who's Claimed (F2-6)** — giver accept/decline pending claim trước pickup | Claude Code | [x] | [77a98f0](https://github.com/thanks-org/thanks-app/commit/77a98f0) — pending: Xác nhận/Từ chối buttons; confirmed: "Xác nhận nhận hàng" → PickupConfirmationScreen |
| F7-11 | **Pickup code QR display trong Claim Confirmed (F1-7)** — render QR cho 4-digit code để giver scan | Claude Code | [x] | [47d6afa](https://github.com/thanks-org/thanks-app/commit/47d6afa) — `qr_flutter ^4.1.0`, QrImageView 120×120 phía trên 4 chữ số trong _PickupCodeBlock |

---

## Phase 8 — UI Polish: Mock Images match Prototype (audit 2026-05-02)
> Mục tiêu: đồng bộ toàn bộ ảnh mock trong Flutter app với đúng Unsplash photo ID đã dùng trong prototype HTML.
> Chỉ sửa mock data (URL strings) — không thay đổi layout hay logic.

### Seed — Phase 8 extra

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F8-S1 | **Seed: replace picsum logos — 3 businesses + 3 orgs** — đổi 6 `picsum.photos` còn lại trong `dev_seed.sql` sang Unsplash: Pizza 4P's, Phở Hồng, Ngon Quán, Mái Ấm Hoa Sen, Saigon Animal Rescue, Lá Lành Group | Claude | [x] | Prototype không chỉ định ảnh cho các entity này. Pick theo theme: pizza/1513104890138, pho/1562802378, food/1540189549336, kids/1488521787991, dog/1587300003388, volunteers/1593113598332. `dev_seed.sql` không còn picsum URL nào. |

### Flutter — Phase 8

| # | Task | Assignee | Status | Ghi chú |
|---|------|----------|--------|---------|
| F8-1 | **Home Feed item cards — imageUrl + giverImageUrl** — update `mockItems` trong `models/item.dart`: thêm 2 items còn thiếu (bánh mì Pháp, áo sơ mi nam), đồng bộ photo IDs với prototype `2_1_1` | Claude | [x] | Thêm 2 items (5=bánh mì Pháp/Tous Les Jours, 6=áo sơ mi/Đức); replace items cũ 5-6 bằng ghế ăn gỗ + sách KD với đúng photo IDs. 8 items total, match prototype 2_1_1. |
| F8-2 | **Home Feed Top Givers — avatarUrl** — update `mockTopGivers` trong `models/giver.dart`: kiểm tra thứ tự + photo IDs với prototype `2_1_1` | Claude | [x] | Đã verify — all 10 entries match prototype 2_1_1 order & photo IDs. No changes needed. |
| F8-3 | **Givers Leaderboard — avatars podium + list** — update mock data trong `givers_screen.dart` / `leaderboard_entry.dart` với photo IDs từ prototype `2_1_2` | Claude | [x] | Leaderboard dùng real API data (không có mock). Root fix: dev_seed.sql business logos (Bento Cooky, Gam Coffee, Tous Les Jours) đã update sang Unsplash photo IDs từ prototype 2_1_2 podium. |
| F8-4 | **Messages — item thumbnails + peer avatars** — update mock conversations với đúng photo IDs từ prototype `2_1_3a` + `2_1_3b` | Claude | [x] | Screen dùng real API data. Item thumbnails = post_images, đã sync trong F8-3/F8-9. Peer avatars dùng pravatar.cc (functional). Prototype không dùng Unsplash cho peer avatars. |
| F8-5 | **Item Detail — hero images + giver avatar** — update mock images list (carousel) + giver avatar URL theo prototype `2_4_1` | Claude | [x] | Screen dùng real API. P01 (Lacoste) hero = photo-1489987707025, đã có trong dev_seed.sql post_images. Giver avatar = pravatar.cc. |
| F8-6 | **Claim Confirmed — item image** — update mock item image URL theo prototype `2_4_2` | Claude | [x] | Screen dùng real API. Claim confirmed dùng item từ P01 — photo-1489987707025 đã có trong dev_seed.sql. |
| F8-7 | **My Items Personal + Business — item thumbnails + business logo** — update mock data trong `my_items_personal_screen.dart` + `my_items_business_screen.dart` theo prototype `2_2_3` + `2_2_4` | Claude | [x] | Root fix: dev_seed.sql post_images — P03 → photo-1503602642458, P04 thêm mới photo-1556228720, P07 → photo-1546069901, P08 thêm mới photo-1606787366850. |
| F8-8 | **Manage Businesses — business logos** — update mock businesses với đúng logo photo IDs theo prototype `2_2_5` | Claude | [x] | Screen dùng real API data. Root fix: Bento Cooky + Gam Coffee logo_url trong dev_seed.sql → Unsplash photo IDs từ prototype 2_2_5. |
| F8-9 | **Giver Public Profiles — business header + item images** — update mock data trong `giver_public_business_screen.dart` + `public_profile_screen.dart` theo prototype `2_2_1` + `2_2_2` | Claude | [x] | Screen dùng real API data. Root fix: post_images table trong dev_seed.sql — tất cả 17 entries updated từ picsum sang Unsplash photo IDs match prototype. | Files: `giver_public_business_screen.dart`, `public_profile_screen.dart` |
| F8-10 | **Submit Item Step 1 — photo upload previews** — update mock pre-selected thumbnails (3 ảnh) theo prototype `2_2_7` | Claude | [x] | N/A — screen dùng `List<XFile>` từ device image picker, không có hardcoded URLs. Prototype chỉ illustrate trạng thái sau khi user chọn ảnh từ gallery. |

---

## Dependency map (tóm tắt)

```
B1-1 (JWT middleware)
  └── B1-2, B1-3, B1-4, B2-*, B3-*, B4-*, B5-*, B6-*

I1-1 (file storage)
  └── B4-1 (POST /uploads)
        └── B4-2 (POST /posts), B6-3, B6-6

B2-1 (GET /posts)
  └── F1-5 (Home Feed → API)

B1-2 + B1-3 (OTP)
  └── F1-4 (Auth screen)
        └── F1-5, F1-6, F1-7 ...

B4-1 (uploads)
  └── F2-1 (upload service)
        └── F2-2, F2-3 (submit item screens)

B7-1 (GET /me/notifications)
  └── F5-5 (notifications inbox), F5-11 (badge thật)

B7-2 (search + sort params)
  └── F5-6 (search bar), F5-9 (sort tabs)
```

---

## Cách cập nhật file này

- Khi nhận task: đổi `[ ]` → `[~]`, ghi tên mình vào Assignee, commit
- Khi xong task: đổi `[~]` → `[x]`, ghi commit hash vào Ghi chú, commit
- Khi thêm task mới: thêm dòng mới vào đúng phase, assign người
