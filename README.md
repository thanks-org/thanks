# Thanks

Community item-sharing app cho Việt Nam — người có đồ thừa tặng miễn phí cho người cần.

## Repositories

| Repo | Mô tả | Stack |
|------|--------|-------|
| [thanks-backend](https://github.com/thanks-org/thanks-backend) | REST API server | Go, PostgreSQL |
| [thanks-app](https://github.com/thanks-org/thanks-app) | Mobile app | Flutter |
| [thanks-infra](https://github.com/thanks-org/thanks-infra) | Local dev environment | Docker Compose |

## Setup lần đầu

**Yêu cầu:** Git, [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Flutter 3.19+](https://flutter.dev/docs/get-started/install)

```bash
# 1. Clone repo này và tất cả sub-repos
git clone https://github.com/thanks-org/thanks.git
cd thanks
chmod +x setup.sh && ./setup.sh

# 2. Khởi động backend (PostgreSQL + migrations + API server)
cd thanks-infra && cp .env.example .env && make up

# 3. Chạy app (terminal mới)
cd thanks-app && flutter run
```

Kiểm tra backend: mở http://localhost:8080/health — nếu thấy `{"status":"ok"}` là thành công.

> **Không cần cài Go.** Backend chạy hoàn toàn trong Docker với hot-reload.

## Tài liệu

- **Prototype**: https://minhidea.com/#thanks
- **API documentation**: [word_idea_to_api_doc/api_doc.html](word_idea_to_api_doc/api_doc.html)
- **Công việc hiện tại**: [WORKLOG.md](WORKLOG.md)

## Tham gia phát triển

1. Đọc [WORKLOG.md](WORKLOG.md) xem task nào đang available
2. Claim task: điền tên + ngày vào cột "In Progress", commit WORKLOG.md
3. Branch từ `develop`, code, tạo PR, chờ review rồi merge
4. Khi xong: chuyển task sang Done, điền commit/PR link, commit WORKLOG.md
