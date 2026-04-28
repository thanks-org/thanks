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

### Trước khi bắt đầu task
- Đọc WORKLOG.md
- Claim task: điền tên + ngày vào cột "In Progress"
- Commit WORKLOG.md lên repo `thanks` để người khác thấy

### Khi làm xong task
- Update WORKLOG.md: chuyển task sang Done, điền commit/PR link
- Commit WORKLOG.md lên repo `thanks`

### Git workflow
- Branch từ `develop`: `git checkout -b feature/ten-feature`
- Không push thẳng lên `main`
- Tạo PR vào `develop`, cần 1 người review trước khi merge

### Tham chiếu
- Mỗi API endpoint trong `api_and_doc/api_doc.html` ghi rõ xuất phát từ screen nào
- Mỗi screen trong `idea_img_to_word/thanks_screens.md` ghi rõ từng element, từng field
- Database schema diagram: `api_and_doc/schema.html`
- Database schema SQL: `thanks-backend/migrations/000001_init.up.sql`
