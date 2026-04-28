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
```

---

## Cách cập nhật file này

- Khi nhận task: đổi `[ ]` → `[~]`, ghi tên mình vào Assignee, commit
- Khi xong task: đổi `[~]` → `[x]`, ghi commit hash vào Ghi chú, commit
- Khi thêm task mới: thêm dòng mới vào đúng phase, assign người
