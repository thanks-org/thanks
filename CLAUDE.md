# Claude Code — Project Instructions

Đây là project **Thanks**: community item-sharing app cho Việt Nam.

## Bắt buộc đọc trước khi làm bất cứ việc gì

1. Đọc `WORKLOG.md` — xem ai đang làm gì, task nào còn trong backlog
2. Đọc `idea_img_to_word/thanks_screens.md` — mô tả chi tiết toàn bộ screens của app
3. Đọc `api_and_doc/api_doc.html` — toàn bộ API endpoints và schema
4. Xem `api_and_doc/schema.html` — database schema diagram (table relationships)

## Cấu trúc project

```
thanks/                        ← repo này (coordination hub)
├── WORKLOG.md                 ← log công việc — ĐỌC TRƯỚC, UPDATE SAU
├── CLAUDE.md                  ← file này
├── idea_img_to_word/          ← mô tả prototype bằng text
├── idea_to_static_html/       ← prototype screens dạng static HTML
└── api_and_doc/               ← tài liệu API + DB schema diagram

thanks-backend/                ← Go API server (clone riêng)
thanks-app/                    ← Flutter mobile app (clone riêng)
thanks-infra/                  ← Docker + PostgreSQL (clone riêng)
```

## Tech stack

- **Backend**: Go + Gin + pgx + PostgreSQL 16
- **App**: Flutter 3.x (iOS + Android)
- **Infra**: Docker Compose (local dev), Railway (staging)
- **Auth**: JWT, OTP qua SMS, Social login (Zalo, Google, Facebook, Apple)

## Quy tắc làm việc

### Git workflow — làm thẳng trên `main`

Không cần tạo branch. Mọi Claude session đều commit thẳng lên `main`.

**Trước khi bắt đầu viết code:**
1. `git pull` để lấy code mới nhất
2. Đọc WORKLOG.md — kiểm tra xem có session nào đang làm task trùng không
3. Claim task: điền tên + ngày vào cột "In Progress" trong WORKLOG.md
4. `git add WORKLOG.md && git commit -m "chore: claim task [tên task]" && git push`

**Khi làm xong task:**
1. Update WORKLOG.md: chuyển task sang Done, điền commit hash
2. `git add -A && git commit -m "..." && git push`

**Nếu gặp conflict khi pull:**
- Xem file nào conflict: `git status`
- Nếu conflict ở WORKLOG.md: merge thủ công (giữ cả 2 phần In Progress), rồi tiếp tục
- Nếu conflict ở code: đọc cả 2 version, chọn version đúng nhất, commit

**Chỉ chạy git khi thực sự viết code.** Không cần git pull/push cho các câu trả lời giải thích hoặc đọc tài liệu.

### Tham chiếu
- Mỗi API endpoint trong `api_and_doc/api_doc.html` ghi rõ xuất phát từ screen nào
- Mỗi screen trong `idea_img_to_word/thanks_screens.md` ghi rõ từng element, từng field
- Database schema diagram: `api_and_doc/schema.html`
- Database schema SQL: `thanks-backend/migrations/000001_init.up.sql`
