# Thanks — Scenarios

> File này liệt kê toàn bộ user scenarios có thể xảy ra trong app.
> Dùng để review xem đã implement đủ chưa.
>
> **Status:**
> ✅ Done (backend + Flutter hoạt động end-to-end)
> 🚧 Partial (UI có nhưng stub / "Coming soon" / thiếu một phía)
> ❌ Not implemented (chưa có gì)
> ⏸ Deferred (blocked on external dependency)
>
> Cập nhật lần cuối: 2026-04-30

---

## App là gì

**Thanks** — người có đồ thừa (Giver) tặng miễn phí cho người cần (Receiver) qua app.
Giver có thể là cá nhân hoặc doanh nghiệp. Receiver có thể là cá nhân hoặc tổ chức từ thiện.

---

## Actors

| Actor | Mô tả |
|-------|-------|
| **Guest** | Chưa đăng nhập. Có thể xem nhưng không claim. |
| **Personal Giver** | Cá nhân tặng đồ dùng cá nhân. |
| **Business Giver** | Tặng dưới danh nghĩa doanh nghiệp (cần verified). |
| **Personal Receiver** | Cá nhân nhận đồ cho bản thân / gia đình. |
| **Org Receiver** | Đại diện tổ chức nhận hàng loạt (cần verified org). |

---

## A. Browse & Discovery

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| A-01 | Mở app, xem Home Feed danh sách items đang active | Guest | 2.1.1 | ✅ |
| A-02 | Filter feed theo category (food / clothes / books / furniture / tech) | Guest | 2.1.1 | ✅ |
| A-03 | Search item theo keyword (tên, mô tả) | Guest | 2.1.1 | ✅ |
| A-04 | Sort feed: Gần nhất / Mới nhất / Sắp hết | Guest | 2.1.1 | ✅ |
| A-05 | Xem chi tiết một item (ảnh carousel, mô tả, giver info, pickup window) | Guest | 2.4.1 | ✅ |
| A-06 | Xem public profile giver cá nhân (items đang tặng, đánh giá gần đây) | Guest | 2.2.2 | ✅ |
| A-07 | Xem public profile giver business (items, địa chỉ, rating) | Guest | 2.2.1 | ✅ |
| A-08 | Xem public profile receiver cá nhân (trust signals, khu vực) | Guest | 2.3.1 | ✅ |
| A-09 | Xem public profile tổ chức receiver (mission, địa chỉ, verified badge) | Guest | 2.3.2 | ✅ |
| A-10 | Xem Givers Leaderboard — tab All / Business / Personal | Guest | 2.1.2 | 🚧 UI done, `giver_type` filter chưa có backend (B-new-2) |
| A-11 | Leaderboard filter theo thời gian: Week / Month / All-time | Guest | 2.1.2 | 🚧 UI done, `period` filter chưa có backend (B-new-2) |
| A-12 | Top Business Givers strip trên Home Feed | Guest | 2.1.1 | ✅ |
| A-13 | Xem "Similar items" khi Item Detail hết slot / đã đóng | Guest | 2.4.1 | ❌ Chưa có recommendation (F-new-6) |

---

## B. Auth

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| B-01 | Xem Profile logged-out, bấm Đăng nhập | Guest | 2.1.5 | ✅ |
| B-02 | Chọn role khi sign up: Người tặng / Người nhận (chỉ 2 lựa chọn, cố định) | Guest | 2.1.6 | 🚧 UI có, nhưng hard-code "Người nhận" — onboarding role picker chưa wire (F5-10) |
| B-03 | Sign up / login bằng Google | Guest | 2.1.6 | 🚧 Dev mode hoạt động (fake id_token); production cần Android/iOS Client ID |
| B-04 | Sign up / login bằng Zalo | Guest | 2.1.6 | ⏸ "Coming soon" — cần Zalo Open API App ID |
| B-05 | Sign up / login bằng Facebook | Guest | 2.1.6 | ⏸ "Coming soon" — cần FB App ID + Secret |
| B-06 | Sign up / login bằng Apple | Guest | 2.1.6 | ⏸ "Coming soon" — cần Apple Services ID |
| B-07 | Sign up / login bằng phone + OTP SMS | Guest | 2.1.6 | ⏸ Deferred — cần ESMS/Twilio account |
| B-08 | Đăng xuất (invalidate JWT server-side) | Any | 2.1.4a/c | ✅ |

---

## C. Giver — Đăng item

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| C-01 | Đăng item một lần (one-time): ảnh → title → category → số lượng → lịch pickup → địa điểm | Personal Giver | 2.2.7, 2.2.8 | ✅ |
| C-02 | Đăng item tái diễn (recurring, e.g. bánh mì mỗi ngày Mon–Sat) | Business Giver | 2.2.7, 2.2.8 | ✅ |
| C-03 | Đăng item dưới danh nghĩa business (gắn business_id) | Business Giver | 2.2.7, 2.2.8 | ✅ |
| C-04 | Upload nhiều ảnh cho item (min 1, dùng POST /uploads) | Giver | 2.2.7 | ✅ (local storage tạm — swap sang R2/S3 khi I1-1 xong, B-new-5) |
| C-05 | AI suggest description / category từ ảnh | Giver | 2.2.7 | ⏸ Deferred — chưa có AI service |
| C-06 | Edit post (title, description, pickup window) | Giver | 2.2.3 / 2.2.4 | ✅ |
| C-07 | Huỷ post đang active — notify claimants | Giver | 2.2.3 / 2.2.4 | ✅ backend; Flutter: confirm dialog trước khi cancel |

---

## D. Giver — Quản lý items & claims

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| D-01 | Xem My Items (Personal) — tabs: Available / Completed | Personal Giver | 2.2.3 | ✅ |
| D-02 | Xem My Items (Business) — filter theo business | Business Giver | 2.2.4 | ✅ |
| D-03 | Xem Who's Claimed — danh sách người đã claim một item kèm status | Giver | 2.4.3 | ✅ |
| D-04 | Xác nhận claim của receiver → tạo pickup code | Giver | 2.4.3 | ✅ backend; Flutter: confirm button trong Who's Claimed |
| D-05 | Xem impact stats (tổng items đã tặng, số thank-you notes nhận) | Giver | 2.2.9 | ✅ |
| D-06 | Rating receiver sau khi pickup xong | Giver | 2.1.3b | ✅ |
| D-07 | Giver đánh dấu receiver no-show | Giver | — | ❌ Schema có `claims.no_show_at` nhưng chưa có UI / endpoint |

---

## E. Receiver — Claim & nhận item

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| E-01 | Claim một item (bấm Nhận) — backend sinh pickup code | Receiver | 2.4.1 → 2.4.2 | ✅ |
| E-02 | Xem Claim Confirmed: pickup code + địa chỉ + cửa sổ thời gian | Receiver | 2.4.2 | ✅ |
| E-03 | Copy pickup code (tap / long-press) | Receiver | 2.4.2 | ✅ |
| E-04 | Share pickup code qua share sheet | Receiver | 2.4.2 | ✅ |
| E-05 | Mở Google Maps / chỉ đường đến điểm pickup | Receiver | 2.4.2 | ✅ |
| E-06 | Nhắn tin với giver từ Claim Confirmed | Receiver | 2.4.2 → 2.1.3a | ✅ |
| E-07 | Huỷ claim đang pending | Receiver | 2.4.2 | ✅ |
| E-08 | Rating giver sau khi pickup | Receiver | 2.1.3a | ✅ |
| E-09 | Gửi thank-you note cho giver sau pickup | Receiver | 2.2.9 | ❌ Backend chưa có `POST /claims/:id/thanks` (B-new-1), Flutter F-new-1 |
| E-10 | Claim dưới danh nghĩa tổ chức (gắn organization_id) | Org Receiver | 2.4.1 | 🚧 Schema có `claims.organization_id`, UI chưa có flow chọn org khi claim |
| E-11 | Xem lịch sử claims của tôi (My Claims) | Receiver | 2.1.4c | ✅ |
| E-12 | Org đăng "request cần nhận" loại đồ nào (demand posting) | Org Receiver | — (tính năng mới) | ❌ Tính năng mới — hiện chỉ givers post offer (Journey 13, B-new-13) |

---

## F. Messaging

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| F-01 | Xem danh sách conversations (receiver view — grouped by claim) | Receiver | 2.1.3a | ✅ |
| F-02 | Xem danh sách conversations (giver view — grouped by claimant) | Giver | 2.1.3b | ✅ |
| F-03 | Mở thread, xem lịch sử tin nhắn của một claim | Both | 2.1.3a/b | ✅ |
| F-04 | Gửi tin nhắn trong thread | Both | 2.1.3a/b | ✅ |
| F-05 | Unread badge trên bottom nav Messages tab (poll mỗi 30s) | Both | 2.1.3a/b | ✅ |
| F-06 | Rating dialog xuất hiện trong thread khi claim status = completed | Giver | 2.1.3b | ✅ |
| F-07 | Real-time messaging (WebSocket) | Both | — | ❌ Chưa implement — hiện HTTP polling |

---

## G. Identity — Business

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| G-01 | Đăng ký business mới: tên, category, logo, địa chỉ, phone, description | Giver | 2.2.6 | ✅ |
| G-02 | Xem danh sách businesses của tôi (Manage Businesses) | Giver | 2.2.5 | ✅ |
| G-03 | Xem badge status: Verified / Pending / Rejected / Action needed | Giver | 2.2.5 | ✅ |
| G-04 | Chỉnh sửa thông tin business | Giver | 2.2.6 | ✅ |
| G-05 | Business được admin verify → có thể đăng bài dưới business name | Admin | — | 🚧 Backend status column có, chưa có admin panel |
| G-06 | Owner mời staff vào business (nhập email/phone, role `staff` → gửi invite) | Business Owner (`owner`) | — (F-new-4) | ❌ Invite model chưa implement (B-new-8/9, F-new-4) |
| G-07 | Staff chấp nhận invite → business xuất hiện trong Manage Businesses với badge "Nhân viên" | Giver (invitee) | — (F-new-8) | ❌ Phụ thuộc G-06 (B-new-11, F-new-8) |
| G-08 | Owner xoá staff → mất quyền post/confirm dưới business ngay lập tức | Business Owner (`owner`) | — (F-new-4) | ❌ Phụ thuộc G-06 (B-new-12) |
| G-09 | Owner xem danh sách thành viên business (tên, role, ngày tham gia) | Business Owner | — (F-new-4) | ❌ Phụ thuộc B-new-14, F-new-4 |
| G-10 | Invitee từ chối lời mời vào business | Giver (invitee) | — (F-new-8) | ❌ Phụ thuộc B-new-15, F-new-8 |

---

## H. Identity — Organization

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| H-01 | Đăng ký tổ chức mới: tên, category, logo, địa chỉ, contact person | Receiver | 2.3.4 | ✅ (thiếu `address_detail` column — B-new-3) |
| H-02 | Xem danh sách organizations của tôi (Manage Organizations) | Receiver | 2.3.3 | ✅ |
| H-03 | Xem badge status: Verified / Pending / Rejected / Action needed | Receiver | 2.3.3 | ✅ |
| H-04 | Chỉnh sửa thông tin organization | Receiver | 2.3.4 | ✅ |
| H-05 | Org được admin verify → có thể claim dưới tên tổ chức | Admin | — | 🚧 Backend status column có, chưa có admin panel |
| H-06 | Admin mời member vào org (nhập email/phone, role `member` → gửi invite) | Org Admin (`admin`) | — (F-new-5) | ❌ Invite model chưa implement (B-new-8/10, F-new-5) |
| H-07 | Member chấp nhận invite → có thể claim dưới danh nghĩa org khi browse feed | Org Member (invitee) | — (F-new-8) | ❌ Phụ thuộc H-06 (B-new-11, F-new-8) |
| H-08 | Admin xoá member → mất quyền claim dưới danh nghĩa org ngay lập tức | Org Admin (`admin`) | — (F-new-5) | ❌ Phụ thuộc H-06 (B-new-12) |
| H-09 | Admin xem danh sách thành viên org (tên, role, ngày tham gia, số lần claim) | Org Admin | — (F-new-5) | ❌ Phụ thuộc B-new-14, F-new-5 |
| H-10 | Invitee từ chối lời mời vào org | Org Member (invitee) | — (F-new-8) | ❌ Phụ thuộc B-new-15, F-new-8 |

---

## I. Profile & Settings

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| I-01 | Xem profile của mình khi logged in (giver view) | Giver | 2.1.4a / 2.1.4b | ✅ |
| I-02 | Xem profile của mình khi logged in (receiver view) | Receiver | 2.1.4c | ✅ |
| I-03 | Edit profile: tên, bio | Any | 2.1.4d | ✅ |
| I-04 | Upload / thay avatar | Any | 2.1.4d | ✅ |
| I-05 | Toggle notification: push / email | Any | 2.1.4d | 🚧 Local state only — chưa persist lên server (B-new-4) |
| I-06 | Xem public profile của người khác (tap từ item card hoặc Who's Claimed) | Any | 2.2.1/2/3.1/3.2 | ✅ |

---

## J. Notifications

| # | Scenario | Actor | Screens | Status |
|---|----------|-------|---------|--------|
| J-01 | Nhận in-app notification khi claim được giver confirm | Receiver | — | ✅ row ghi vào DB; FCM push chờ I4-1 |
| J-02 | Nhận in-app notification khi có tin nhắn mới | Both | — | ✅ row ghi vào DB; FCM push chờ I4-1 |
| J-03 | Nhận in-app notification khi nhận rating mới | Both | — | ✅ row ghi vào DB; FCM push chờ I4-1 |
| J-04 | Nhận in-app notification khi post bị cancel (claimant nhận thông báo) | Receiver | — | ✅ row ghi vào DB; FCM push chờ I4-1 |
| J-05 | Xem Notifications Inbox (pull-to-refresh, infinite scroll) | Any | Notif screen | ✅ |
| J-06 | Mark all notifications as read (auto khi mở inbox) | Any | Notif screen | ✅ |
| J-07 | Unread badge trên bell icon Home Feed | Any | 2.1.1 | ✅ |
| J-08 | FCM push notification (thiết bị nhận push khi app background) | Any | — | ❌ I4-1 chưa implement |

---

## K. Edge Cases & Error States

| # | Scenario | Xử lý hiện tại | Status |
|---|----------|----------------|--------|
| K-01 | Item hết hàng (quantity_remaining = 0) → Claim button disabled | Backend: decrement atomic; Flutter: disabled state | ✅ |
| K-02 | Item hết hạn / đã đóng (status = completed / cancelled) | Item vẫn hiển thị nhưng không thể claim | ✅ |
| K-03 | Giver claim item của chính mình | Backend trả 403 self-claim | ✅ |
| K-04 | Receiver claim trùng (đã có active claim trên item này) | Backend trả 409 duplicate | ✅ |
| K-05 | Recurring item (daily schedule) — còn active ngày mai | `post_schedules` + `is_recurring = true` | ✅ |
| K-06 | Guest bấm Claim → redirect đến sign up | Flutter guard: check auth trước khi claim | ✅ |
| K-07 | Giver cancel post khi đang có claimants → notify họ | Backend set status cancelled + write notification rows | ✅ (FCM chờ I4-1) |
| K-08 | Receiver no-show — giver muốn đánh dấu | Schema có `claims.no_show_at` | ❌ Không có UI / endpoint |
| K-09 | Search không có kết quả → empty state | Flutter: "Không tìm thấy 'query'" | ✅ |
| K-10 | Không cho phép location → sort Gần nhất bị vô hiệu | Flutter: disable sort + hiện label | ✅ |
| K-11 | Network error / timeout | Đa phần là `CircularProgressIndicator` đơn giản | 🚧 F5-8 chưa làm (empty/error states chuẩn) |
| K-12 | Business / Org đang pending_review → giver chờ admin duyệt | UI hiện badge "Đang xét duyệt" | ✅ |
| K-13 | Business / Org bị rejected → giver nhận thông báo action needed | UI hiện badge "Từ chối" | 🚧 Notification row chưa có cho rejected event |
| K-14 | Limit per receiver: giver set max quantity một người được nhận | `claims.quantity` validate với `posts.limit_per_receiver` | ✅ backend; Flutter form có field |
| K-15 | Item hết hạn (expires mà không ai pickup) → app gợi ý re-post | Giver | 2.2.3 / notif | ❌ Chưa có re-post suggestion (Journey 10, F-new-7) |

---

## Tóm tắt trạng thái

| Tổng | ✅ Done | 🚧 Partial | ❌ Chưa làm | ⏸ Deferred |
|------|---------|------------|------------|------------|
| 103 scenarios | 70 | 10 | 18 | 5 |

> Cập nhật 2026-04-30: đếm lại thực tế từng dòng (count cũ "67" là stale từ trước Phase 5 audit).
> ⏸ gồm: B-04, B-05, B-06, B-07 (social login providers), C-05 (AI suggest).
> ❌ 18 gồm: D-07, E-09, E-12, F-07, G-06→10, H-06→10, J-08, K-08, K-15.

### Những gì quan trọng nhất còn thiếu

1. **E-09 / B-new-1** — `POST /claims/:id/thanks` + Flutter UI (thanks note sau pickup)
2. **A-10 / A-11 / B-new-2** — Leaderboard filter `giver_type` + `period`
3. **H-01 / B-new-3** — `organizations.address_detail` column (migration)
4. **I-05 / B-new-4** — Notification preferences persist
5. **J-08 / I4-1** — FCM push notifications thật
6. **G-06→10 / H-06→10** — Invite model (business + org members): B-new-8→12/14/15, F-new-4/5/8
7. **E-10 / F-new-3** — Claim dưới danh nghĩa org (UI flow)
8. **D-07 / K-08 / B-new-6** — Giver mark receiver no-show
9. **F-07** — Real-time messaging (WebSocket)
10. **K-11 / F5-8** — Empty/error states chuẩn hóa
11. **A-13 / F-new-6** — Similar items recommendation khi item hết slot
12. **K-15 / F-new-7** — Re-post gợi ý sau khi item hết hạn
13. **E-12 / B-new-13** — Org đăng "request cần nhận" (tính năng mới, post-MVP)
