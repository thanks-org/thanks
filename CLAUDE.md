# Thanks — Claude Session Brief

> File này được Claude Code load tự động. Đọc xong file này là đủ context để bắt đầu.
> Chỉ đọc thêm file khác khi thực sự cần cho task cụ thể.

---

## App là gì

**Thanks** — community item-sharing app cho Việt Nam. Người có đồ thừa tặng miễn phí cho người cần.

**Tech stack:**
- Backend: Go + Gin + pgx + PostgreSQL 16 (repo: `thanks-backend`)
- App: Flutter 3.x iOS + Android (repo: `thanks-app`)
- Infra: Docker Compose local, Railway staging (repo: `thanks-infra`)
- Auth: JWT, OTP SMS, Social login (Zalo, Google, Facebook, Apple)

---

## Trạng thái hiện tại (cập nhật: 2026-04-28)

### Đã xong
- Go backend skeleton + DB migrations (users, posts, claims, messages, ratings, businesses, orgs, auth_providers, sessions, notifications, v.v.)
- Docker Compose + PostgreSQL — `make up` là chạy, hot-reload với Air
- Flutter app skeleton + Home Feed screen (mock data, match prototype)
- App icon + branding (cream, terracotta, Plus Jakarta Sans 800)
- Prototype → 26 screen descriptions (`idea_img_to_word/thanks_screens.md`)
- API doc HTML (`api_and_doc/api_doc.html`) + DB schema diagram (`api_and_doc/schema.html`)

### Đang làm
Xem `WORKLOG.md` → bảng **In Progress** (file ngắn, đọc < 5s).

### Backlog — ưu tiên cao
| Task | Repo |
|------|------|
| Auth API — POST /auth/otp/send + /verify | thanks-backend |
| Auth API — POST /auth/social (Zalo/GG/FB/Apple) | thanks-backend |
| Posts API — GET /posts (feed) + POST /posts | thanks-backend |
| Claims API — POST /posts/:id/claims (tạo pickup code) | thanks-backend |
| Flutter: Auth screens (phone + OTP) | thanks-app |
| Flutter: Item Detail + Claim Confirmed screens | thanks-app |
| Flutter: Submit Item screens (Step 1 + 2) | thanks-app |

---

## Cấu trúc repo

> **QUAN TRỌNG:** `thanks-app`, `thanks-backend`, `thanks-infra` là **subfolders nằm BÊN TRONG working directory này**. Khi tìm file, dùng relative path từ đây:
> - Flutter app: `thanks-app/`
> - Go backend: `thanks-backend/`
> - Infra: `thanks-infra/`
>
> **KHÔNG** tìm các folder này ở ngoài working directory hiện tại.

```
thanks/                        ← working directory (repo coordination hub)
├── CLAUDE.md                  ← file này — đọc đầu tiên
├── WORKLOG.md                 ← task tracker — claim trước khi code
├── thanks-app/                ← Flutter app (iOS + Android)
├── thanks-backend/            ← Go + Gin backend
├── thanks-infra/              ← Docker Compose + Railway config
├── idea_img_to_word/
│   └── thanks_screens.md      ← mô tả 26 screens (đọc khi làm Flutter)
├── idea_to_static_html/       ← prototype screens dạng static HTML
└── api_and_doc/
    ├── api_doc.html            ← API endpoints (đọc khi làm API)
    └── schema.html             ← DB schema diagram (đọc khi cần DB)
```

---

## Quy trình làm task

### Khi bắt đầu session
1. Đọc **WORKLOG.md** (bảng In Progress) — kiểm tra ai đang làm gì để tránh đụng hàng
2. Tìm task cần làm trong **TASKS.md** — toàn bộ backlog chia theo phase và người
3. Claim task: điền tên + ngày vào WORKLOG.md (In Progress), đổi `[ ]` → `[~]` trong TASKS.md
4. `git pull && git add WORKLOG.md TASKS.md && git commit -m "chore: claim task [tên task]" && git push`

### Chỉ đọc thêm khi cần
| Đang làm gì | Thì đọc |
|-------------|---------|
| Implement API endpoint | phần đó trong `api_and_doc/api_doc.html` |
| Build Flutter screen | screen đó trong `idea_img_to_word/thanks_screens.md` |
| Thiết kế / thay đổi DB | `api_and_doc/schema.html` + `thanks-backend/migrations/` |
| Cần biết SQL schema | `thanks-backend/migrations/000001_init.up.sql` |

**Không đọc toàn bộ docs khi không cần.** Tìm đúng section, đọc đúng phần.

### Git workflow — làm thẳng trên `main`

**Chỉ chạy git khi thực sự viết code.** Không cần git pull/push cho các câu trả lời giải thích hoặc đọc tài liệu.

- Không tạo branch. Commit thẳng lên `main`.
- Khi xong: update WORKLOG.md (Done), điền commit hash, push.
- Nếu conflict ở WORKLOG.md: merge thủ công (giữ cả 2 phần In Progress).

### Khi làm xong
1. Đổi `[~]` → `[x]` trong TASKS.md, ghi commit hash
2. Chuyển task sang Done trong WORKLOG.md
3. Commit + push cả hai file

### Tham chiếu nhanh
- Mỗi API endpoint trong `api_doc.html` ghi rõ xuất phát từ screen nào
- Mỗi screen trong `thanks_screens.md` ghi rõ từng element, từng field
- DB schema SQL đầy đủ: `thanks-backend/migrations/000001_init.up.sql`

---

## Seed data

Khi người dùng nói "start DB", "seed data", hoặc "chạy app", **hỏi trước**:

> "Dùng **dev seed** (data prototype cho tất cả screens) hay **prod seed** (chỉ reference data)?"

| | Dev seed | Prod seed |
|--|--|--|
| Dùng khi | Dev / test / UI smoke | Staging / production baseline |
| Dữ liệu | Prototype-quality, tất cả FKs connect | Chỉ reference (hiện chưa có gì) |
| ⚠️ Destructive | Wipe toàn bộ app data trước | Không xóa gì |
| Lệnh (từ `thanks-backend/`) | `make seed-dev` | `make seed-prod` |
| Xóa không re-seed | `make seed-clear` | — |

**Dev seed bao gồm:**
- 6 users: Dev User (test account), Nguyễn Văn Phượng (business giver), Trần Thị Mai (personal giver #1), Lê Minh Đức (org admin), Phạm Thị Hoa (personal receiver), Hoàng Minh Tuấn (personal giver #2)
- 2 businesses: Bánh Mì Phượng (verified), Cà Phê Nhớ (pending — dev user's)
- 1 organization: Mái Ấm Thiên Tâm (verified)
- 7 posts: 5 active (food/clothes/books/furniture/tech) + 2 completed (for leaderboard history)
- 10 claims: status đa dạng (pending / confirmed / completed / picked_up)
- Messages, ratings, thanks, notifications cho Dev User

**Dev User** (UUID `00000000-0000-0000-0000-000000000001`):
- `auth_providers`: provider=`google`, provider_user_id=`dev-user-001`
- Claim đang confirmed: bánh mì, pickup_code=`A4B7C2`
- Business đang pending: Cà Phê Nhớ
- Leaderboard rank #3 (3 items tặng qua sách)
