# Thanks

Community item-sharing app cho Việt Nam — người có đồ thừa tặng miễn phí cho người cần.

## Repositories

| Repo | Mô tả | Stack |
|------|--------|-------|
| [thanks-backend](https://github.com/thanks-org/thanks-backend) | REST API server | Go, PostgreSQL |
| [thanks-app](https://github.com/thanks-org/thanks-app) | Mobile app | Flutter |
| [thanks-infra](https://github.com/thanks-org/thanks-infra) | Local dev environment | Docker Compose |

## Setup lần đầu

**Yêu cầu:** Git, Docker Desktop, Go 1.22+, Flutter 3.19+

```bash
# 1. Clone repo này
git clone https://github.com/thanks-org/thanks.git
cd thanks

# 2. Chạy setup — tự clone hết các repo còn lại
chmod +x setup.sh
./setup.sh

# 3. Khởi động database
cd thanks-infra && cp .env.example .env && make up && cd ..

# 4. Chạy migrations
cd thanks-backend && cp .env.example .env && make migrate-up && cd ..

# 5. Chạy backend (terminal 1)
cd thanks-backend && make run

# 6. Chạy app (terminal 2)
cd thanks-app && flutter run
```

Mở http://localhost:8080/health — nếu thấy `{"status":"ok"}` là backend đang chạy.

## Tài liệu

- **Prototype**: https://minhidea.com/#thanks
- **Screen descriptions**: [idea_img_to_word/thanks_screens.md](idea_img_to_word/thanks_screens.md)
- **API documentation**: [word_idea_to_api_doc/api_doc.html](word_idea_to_api_doc/api_doc.html)
- **Công việc hiện tại**: [WORKLOG.md](WORKLOG.md)

## Tham gia phát triển

1. Đọc [WORKLOG.md](WORKLOG.md) xem task nào đang available
2. Claim task, bắt đầu làm, update WORKLOG khi xong
3. Branch từ `develop`, tạo PR, chờ review rồi merge
