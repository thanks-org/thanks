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

### Backend (`thanks-backend`)
| Task | Priority | Ghi chú |
|------|----------|---------|
| Auth API — POST /auth/otp/send | 🔴 high | Xem api_doc.html |
| Auth API — POST /auth/otp/verify | 🔴 high | |
| Auth API — POST /auth/social (Zalo/GG/FB/Apple) | 🔴 high | |
| Posts API — GET /posts (browse feed) | 🔴 high | Có filter category, lat/lng |
| Posts API — POST /posts (create) | 🔴 high | |
| Posts API — GET /posts/:id | 🟡 medium | |
| Claims API — POST /posts/:id/claims | 🔴 high | Tạo pickup code 4 số |
| Claims API — DELETE /claims/:id | 🟡 medium | |
| Messages API — GET + POST /messages | 🟡 medium | |
| File Upload API — POST /uploads | 🟡 medium | |
| Ratings API — POST /claims/:id/ratings | 🟡 medium | |
| Leaderboard API — GET /leaderboard | 🟢 low | |
| Businesses API — CRUD | 🟡 medium | |
| Organizations API — CRUD | 🟢 low | |

### App (`thanks-app`)
| Task | Priority | Ghi chú |
|------|----------|---------|
| Auth screens — phone + OTP | 🔴 high | Screen 2.1.5, 2.1.6 |
| Item Detail screen | 🔴 high | Screen 2.4.1 |
| Claim Confirmed screen | 🔴 high | Screen 2.4.2 — pickup code |
| Submit Item screen — Step 1 | 🔴 high | Screen 2.2.7 |
| Submit Item screen — Step 2 | 🔴 high | Screen 2.2.8 |
| Givers Leaderboard screen | 🟡 medium | Screen 2.1.2 |
| Messages screen (Receiver view) | 🟡 medium | Screen 2.1.3a |
| Messages screen (Giver view) | 🟡 medium | Screen 2.1.3b |
| Profile screen | 🟡 medium | Screen 2.1.4a/c |
| Connect Home Feed to real API | 🟡 medium | Thay mock data bằng API call |

### Infra (`thanks-infra`)
| Task | Priority | Ghi chú |
|------|----------|---------|
| Setup staging server (Railway/Fly.io) | 🟡 medium | Auto-deploy từ develop branch |
| CI/CD pipeline (GitHub Actions) | 🟡 medium | Build + test khi push |
| Push notification setup (FCM) | 🟢 low | |

---

## ✅ Done

| Task | Ai làm | Ngày xong | Commit / PR |
|------|--------|-----------|-------------|
| Go backend skeleton + DB migrations (users, posts, claims, messages, ratings) | Claude Code | 2026-04-27 | [c84fcab](https://github.com/thanks-org/thanks-backend/commit/c84fcab) |
| Docker Compose + PostgreSQL setup | Claude Code | 2026-04-27 | [b8d1a8d](https://github.com/thanks-org/thanks-infra/commit/b8d1a8d) |
| Flutter app skeleton + Home Feed screen (mock data) | Claude Code | 2026-04-27 | [865bba2](https://github.com/thanks-org/thanks-app/commit/865bba2) |
| Prototype → Screen descriptions (thanks_screens.md) | Claude Code | 2026-04-27 | trong repo `thanks` |
| Screen descriptions → API doc HTML (api_doc.html) | Claude Code | 2026-04-27 | trong repo `thanks` |
