# Thanks — User Journeys

> Mô tả các hành trình người dùng thực tế — từ lý do họ vào app đến kết quả cuối cùng.
> Dùng để định hướng product, test end-to-end flow, và phát hiện gaps.
>
> **Quy ước:**
> - Mỗi người dùng chỉ có 1 role: Giver hoặc Receiver (không dùng chung account)
> - Business/Org có thể mời nhiều thành viên quản lý (invite model)
>
> Cập nhật lần cuối: 2026-04-30

---

## Nhóm 1 — Core giver/receiver loop

### Journey 1: Dọn nhà, tặng đồ cũ

> Anh Nam có đồ thừa muốn cho đi. Chị Hoa đang cần đúng thứ đó.

**Personas:** Nam (Giver cá nhân, 32 tuổi, Quận 3) · Hoa (Receiver cá nhân, 28 tuổi, Quận 1)

**Diễn biến:**

1. Nam dọn nhà, có 10 bộ quần áo trẻ em size 2–5 tuổi còn rất tốt. Không muốn bỏ đi, muốn tặng cho ai cần.
2. Nam tải Thanks, đăng ký tài khoản **Giver** bằng Google.
3. Nam chụp ảnh 10 bộ áo, đăng post: category Clothes, số lượng 10, pickup cuối tuần 8h–12h tại nhà Quận 3.
4. Hoa đang tìm đồ cho con. Mở Thanks, browse feed, thấy bài áo trẻ em của Nam cách 2.3km.
5. Hoa (đã có tài khoản **Receiver** từ trước) xem Item Detail, bấm **Nhận**.
6. App sinh pickup code `X3K9P1`. Hoa thấy màn hình Claim Confirmed với code + địa chỉ + cửa sổ pickup.
7. Hoa nhắn tin Nam qua app: *"Anh ơi, em đến 9h Thứ 7 nhé, em lấy 3 bộ thôi."*
8. Nam trả lời: *"Ok em, anh để sẵn 3 bộ cho em."*
9. Thứ 7, Hoa đến, show code. Nam xác nhận, đưa 3 bộ áo.
10. Sau pickup, cả hai rate nhau. Hoa gửi thank-you note: *"Cảm ơn anh! Áo đẹp lắm, con em thích lắm."*
11. Nam nhận note trong Thanks & Ratings screen, thấy vui, lần sau lại tặng tiếp.

**Screens:** 2.2.7 → 2.2.8 → 2.4.1 → 2.4.2 → 2.1.3a/b → 2.2.9
**Gaps:** E-09 (thanks note chưa có endpoint), D-07 (mark no-show chưa có)

---

### Journey 2: Quán ăn tặng cơm thừa mỗi ngày

> Chị Phượng không muốn đổ cơm thừa. Vừa giảm lãng phí, vừa làm điều tốt.

**Personas:** Phượng (Business Giver, chủ Cơm Tấm Phượng, Quận 1) · Nhiều receivers hằng ngày

**Diễn biến:**

1. Mỗi ngày quán Phượng còn 20–30 phần cơm tấm lúc 13h30. Nhân viên vẫn phải đổ đi.
2. Phượng nghe bạn giới thiệu Thanks. Đăng ký tài khoản **Giver** bằng số điện thoại.
3. Phượng thêm business "Cơm Tấm Phượng" — điền tên, category, logo, địa chỉ quán. Business vào trạng thái "Đang xét duyệt".
4. Trong lúc chờ, Phượng chỉ post được dưới tên cá nhân. Sau 2 ngày admin duyệt xong, Phượng nhận notification xác nhận.
5. Phượng tạo post **recurring**: mỗi ngày Thứ 2–Thứ 6, 13h30–14h, 25 phần, tối đa 1 phần/người, đăng dưới tên "Cơm Tấm Phượng".
6. Ngày đầu có 8 receivers claim. Ngày thứ 5 có 25 claim, hết slot trong 10 phút.
7. Receivers đến đúng giờ show pickup code, nhân viên quán đối chiếu và trao cơm.
8. Sau vài tuần, Cơm Tấm Phượng lên top 3 Leaderboard Businesses tại HCM.

**Screens:** 2.2.6 → 2.2.5 → 2.2.7 → 2.2.8 → 2.4.3 → 2.1.2
**Gaps:** B-new-2 (leaderboard `giver_type` + `period` filter chưa có backend)

---

### Journey 3: Sinh viên tìm đồ học tập

> Minh năm 2, cần sách nhưng tiết kiệm tiền. Thanks là nơi đầu tiên anh tìm.

**Personas:** Minh (Receiver, sinh viên, Quận Bình Thạnh)

**Diễn biến:**

1. Đầu năm học, Minh cần bộ sách Toán-Lý-Hóa lớp 12 để ôn thi lại. Bạn bè giới thiệu Thanks.
2. Minh đăng ký tài khoản **Receiver** bằng Google.
3. Minh search "sách lớp 12", filter category Books. Thấy 2 bài gần Bình Thạnh.
4. Xem Item Detail bài đầu: giver cách 1.8km, pickup cuối tuần, còn 7/10 bộ. Minh bấm Nhận.
5. Nhận pickup code, copy vào clipboard, share link cho bạn cùng phòng cũng cần.
6. Cuối tuần Minh đến lấy, đúng giờ. Giver đưa sách, rate Minh 5 sao "đúng giờ, lịch sự".
7. Minh rate giver 5 sao. Rating Minh tăng → các givers sau dễ confirm hơn.
8. Minh tiếp tục browse, thấy cơm phần của quán Phượng gần trường — claim mỗi ngày khi đói.

**Screens:** 2.1.1 → 2.4.1 → 2.4.2 → 2.1.3a → 2.1.4c
**Gaps:** không có gaps chính

---

## Nhóm 2 — Business & Organization flows

### Journey 4: Business verification

> Chị Lan muốn tặng bánh thừa mỗi chiều. Nhưng trước tiên cần app tin tưởng mình là business thật.

**Personas:** Lan (Giver, chủ Tiệm Bánh Lan, Quận 5)

**Diễn biến:**

1. Lan có tiệm bánh nhỏ. Mỗi chiều 17h còn 10–15 cái bánh kem sắp hết hạn. Muốn tặng thay vì bỏ.
2. Lan đăng ký Giver, vào **Manage Businesses** → thêm "Tiệm Bánh Lan": logo, địa chỉ, số điện thoại, mô tả.
3. App yêu cầu upload giấy phép kinh doanh. Lan chụp và upload.
4. Business vào trạng thái **Đang xét duyệt** (pending). Lan thấy badge vàng trong Manage Businesses.
5. Lan vẫn có thể post với tên cá nhân trong lúc chờ — nhưng chưa dùng được business identity.
6. Sau 1–2 ngày làm việc, admin duyệt xong. Lan nhận notification: "Tiệm Bánh Lan đã được xác nhận ✓"
7. Lan giờ post dưới tên "Tiệm Bánh Lan". Receivers thấy logo và tên quán, trust cao hơn.

**Screens:** 2.2.6 → 2.2.5
**Gaps:** G-05 (admin panel chưa có — hiện verify thủ công qua DB)

---

### Journey 5: Chuỗi business, mời nhân viên quản lý từng chi nhánh

> Anh Long có 3 chi nhánh. Mỗi chi nhánh manager cần tự post được mà không cần qua Long.

**Personas:** Long (Giver, chủ chuỗi Bún Bò Long 3 chi nhánh, role `owner`) · Ngân (quản lý chi nhánh Quận 3, role `staff`)

**Role model — Business:**

| Role | Quyền |
|------|-------|
| `owner` | Post · Edit · Cancel post · Confirm claim · Xem Who's Claimed · Quản lý thành viên (invite / remove) · Xoá business |
| `staff` | Post · Edit post của mình · Confirm claim · Xem Who's Claimed — **không được** manage members, xoá business |

> Owner là người tạo business (`businesses.user_id`). Staff thêm vào qua invite, lưu trong `business_members`.

**Diễn biến:**

1. Long đăng ký Giver, thêm 3 businesses: "Bún Bò Long — Q1", "Bún Bò Long — Q3", "Bún Bò Long — Bình Thạnh". Cả 3 được verified.
2. Long vào "Bún Bò Long — Q3" → **Quản lý thành viên** → Mời thành viên → nhập email/phone của Ngân, role: `staff`.
3. Ngân nhận notification invite. Ngân mở app (đã có Giver account), bấm **Chấp nhận**.
4. Ngân vào app, thấy "Bún Bò Long — Q3" xuất hiện trong Manage Businesses của mình (badge role: "Nhân viên").
5. Ngân post items dưới tên chi nhánh Q3 mà không cần liên hệ Long.
6. Long vào dashboard của mình vẫn thấy items từ cả 3 chi nhánh. Long không cần làm gì thêm.
7. Khi Ngân nghỉ việc, Long vào Manage Members → xoá Ngân. Ngân mất quyền ngay lập tức.

**Screens:** 2.2.5 → 2.2.6 → (member management screen — F-new-4) → (accept invite screen — F-new-8)
**Gaps:** Invite model chưa implement — B-new-8→12, B-new-14/15; Flutter F-new-4, F-new-8

---

### Journey 6: Tổ chức nhận đồ hàng loạt, nhiều tình nguyện viên cùng hoạt động

> Mái Ấm Thiên Tâm cần 30 bộ quần áo cho trẻ em. Không thể chỉ 1 người đi nhận hết.

**Personas:** Đức (Receiver, admin Mái Ấm Thiên Tâm, role `admin`) · Lan (tình nguyện viên, role `member`) · Mai (giver)

**Role model — Organization:**

| Role | Quyền |
|------|-------|
| `admin` | Claim dưới danh nghĩa org · Quản lý thành viên (invite / remove) · Xem dashboard lịch sử toàn org · Xoá org |
| `member` | Claim dưới danh nghĩa org · Xem lịch sử claim của bản thân trong org — **không được** manage members, xem toàn bộ dashboard |

> Admin là người tạo org (`organizations.user_id`). Member thêm vào qua invite, lưu trong `org_members`.

**Diễn biến:**

1. Đức đăng ký tài khoản Receiver, thêm org "Mái Ấm Thiên Tâm" — upload giấy tờ hoạt động phi lợi nhuận.
2. Org được admin verified sau 2 ngày.
3. Đức invite Lan (tình nguyện viên hay đi nhận đồ) vào org, role: `member`.
4. Lan nhận notification invite, mở app, bấm **Chấp nhận**. Giờ khi Lan browse và claim, Lan có thể chọn claim dưới danh nghĩa **Mái Ấm Thiên Tâm**.
5. Mai đăng 15 bộ áo trẻ em. Lan thấy trên feed, claim 15 bộ dưới tên Mái Ấm, điền lý do cần nhiều.
6. Mai thấy claimant là tổ chức verified → confirm ngay, không cần hỏi thêm.
7. Lan đến pickup, show code. Mai đưa 15 bộ áo.
8. Đức vào dashboard org thấy đầy đủ lịch sử: Lan đã claim gì, khi nào, từ ai.

**Screens:** 2.3.4 → 2.3.3 → 2.4.1 → 2.4.2 → 2.1.3a → 2.3.2 → (member management screen — F-new-5) → (accept invite — F-new-8)
**Gaps:** Invite model org chưa implement — B-new-8/10/11/12, B-new-14/15; E-10 (claim under org UI — F-new-3)

---

## Nhóm 3 — Reputation & Community

### Journey 7: Business cạnh tranh leaderboard

> Hai quán cùng khu vực thấy nhau trên leaderboard. Cạnh tranh lành mạnh → cộng đồng được lợi.

**Personas:** Phượng (Cơm Tấm Phượng) · Hùng (Bánh Mì Hùng, cùng Quận 1)

**Diễn biến:**

1. Phượng đang rank #1 leaderboard Businesses tháng này tại HCM với 380 phần ăn đã tặng.
2. Hùng vào leaderboard, thấy quán mình rank #3 (250 phần). Thấy Phượng rank #1 — cùng quận.
3. Hùng quyết định thêm buổi tặng bánh mì buổi sáng 6h30–7h. Tăng từ 20 lên 35 phần/ngày.
4. Cuối tháng, Hùng lên rank #2. Phượng vẫn #1 nhưng khoảng cách thu hẹp.
5. Cả 2 quán được community chia sẻ trên mạng xã hội. Khách hàng thật tăng.
6. Thanks hiển thị "Top Business Givers tháng này" trên Home Feed — cả 2 xuất hiện ở đó.

**Screens:** 2.1.2 → 2.1.1 (Top strip)
**Gaps:** A-10/A-11 (leaderboard filters chưa có backend — B-new-2)

---

### Journey 8: Receiver xây dựng trust score theo thời gian

> Minh mới dùng app, lúc đầu givers hay chần chừ confirm. Sau vài lần, mọi chuyện khác hẳn.

**Personas:** Minh (Receiver, mới dùng app)

**Diễn biến:**

1. Lần đầu Minh claim, giver thấy rating 0 sao, 0 lần nhận — chờ 1 ngày mới confirm vì chưa trust.
2. Minh đến đúng giờ, lịch sự. Giver rate 5 sao: *"Đúng giờ, không mặc cả, lấy vừa đủ."*
3. Lần 2, 3, 4 — Minh tiếp tục đúng giờ. Rating avg lên 4.8★, 4 lần nhận.
4. Givers bắt đầu confirm ngay khi thấy profile Minh. Có giver còn nhắn: *"Em quen rồi anh confirm liền nhé."*
5. Sau 10 lần nhận, Minh thấy trong profile: "4.9★ · 10 lần nhận · Luôn đúng giờ."
6. Minh trở thành receiver ưu tiên — khi item có nhiều người claim cùng lúc, giver chọn Minh trước.

**Screens:** 2.1.4c → 2.4.3 (giver POV)
**Gaps:** K-09 (chưa có "priority claim" logic — giver chỉ thấy danh sách và tự chọn)

---

## Nhóm 4 — Unhappy paths

### Journey 9: Receiver no-show

> Hoa hẹn đến lấy rồi không đến, không nhắn tin. Nam chờ cả buổi sáng.

**Personas:** Nam (Giver) · Hoa (Receiver)

**Diễn biến:**

1. Hoa claim 3 bộ áo của Nam, hẹn Thứ 7 9h.
2. Thứ 7 sáng, Nam ở nhà chờ. 10h vẫn không thấy Hoa, không có tin nhắn.
3. Nam nhắn qua app: *"Bạn ơi, đến chưa?"* — không có trả lời.
4. 11h hết giờ pickup. Nam vào Who's Claimed → mark claim của Hoa là **No-show**.
5. Hệ thống ghi nhận. Rating Hoa giảm. Slot được giải phóng — Nam có thể confirm cho người khác.
6. Hoa nhận notification: *"Bạn đã bị đánh dấu no-show. Vui lòng liên hệ giver nếu có lý do."*
7. Nếu Hoa no-show nhiều lần, givers sau sẽ thấy badge cảnh báo trên profile Hoa.

**Screens:** 2.4.3 → 2.1.3b
**Gaps:** D-07 / K-08 (mark no-show chưa có UI + endpoint)

---

### Journey 10: Item đăng lên nhưng không ai claim — hết hạn

> Anh Tuấn post tủ lạnh ở Hà Nội. Không ai cần, post tự đóng sau 10 ngày.

**Personas:** Tuấn (Giver, Hà Nội)

**Diễn biến:**

1. Tuấn có tủ lạnh Panasonic 150L còn dùng tốt, dọn nhà cần cho đi gấp. Post lên Thanks.
2. Post có lượt xem nhưng không ai claim. Có thể do: tủ lạnh cồng kềnh, người nhận phải tự vận chuyển, ít người ở khu vực đó dùng app.
3. Sau 10 ngày, `closes_at` đến. Hệ thống tự đổi status → `completed`.
4. Tuấn nhận notification: *"Bài đăng Tủ lạnh Panasonic đã hết hạn mà chưa có ai nhận."*
5. App gợi ý: *"Thử đăng lại với ảnh rõ hơn, hoặc kéo dài thời gian? Bài đăng mới sẽ lên đầu feed."*
6. Tuấn đăng lại, lần này thêm ảnh chi tiết bên trong tủ và ghi rõ *"Người nhận tự vận chuyển, anh hỗ trợ bốc đồ."*
7. Lần 2, có 2 người hỏi. Tuấn confirm người đến sớm hơn.

**Screens:** 2.2.3 → (notification)
**Gaps:** App chưa có gợi ý re-post sau khi expires; K-11 empty state chưa chuẩn (F5-8)

---

### Journey 11: Item hết hàng trước khi kịp claim

> Lan thấy 5 bộ áo đẹp, nhưng chần chừ 30 phút. Khi bấm thì hết rồi.

**Personas:** Lan (Receiver) · Nhiều receivers khác

**Diễn biến:**

1. Lan thấy bài "5 bộ áo trẻ em còn mới" trên Home Feed, đang có 5/5.
2. Lan đọc mô tả kỹ, xem ảnh, suy nghĩ 30 phút mới bấm Nhận.
3. App báo lỗi: *"Xin lỗi, item này vừa hết. Bạn có thể xem các item tương tự."*
4. Lan thấy quantity_remaining = 0, Claim button disabled.
5. App hiển thị gợi ý: items cùng category gần đó đang còn.
6. Lan click xem gợi ý, tìm được bài khác phù hợp hơn.

**Screens:** 2.4.1 → (error state) → 2.1.1
**Gaps:** App chưa có "similar items" recommendation; K-01 đã xử lý đúng

---

## Nhóm 5 — Time-sensitive & Seasonal

### Journey 12: Thức ăn sắp hết hạn — post gấp

> 15h, quán Phượng còn 15 phần cơm, 45 phút nữa đóng cửa. Cần ai đến lấy ngay.

**Personas:** Phượng (Business Giver) · Nhiều receivers gần đó

**Diễn biến:**

1. 15h, nhân viên báo còn 15 phần cơm không bán hết. Phượng mở app, tạo post nhanh dưới business.
2. Title: "Cơm phần miễn phí — lấy trước 16h hôm nay". Pickup window: 15h–16h. Duration: 1 ngày.
3. Receivers có location gần quận 1 nhận notification push (nếu đã bật): *"Cơm tấm miễn phí gần bạn — còn 45 phút!"*
4. Feed sort "Sắp hết hạn" đẩy bài này lên đầu cho người dùng gần đó.
5. Trong 20 phút, 15 claim xong. Phượng thấy Who's Claimed đầy đủ.
6. Receivers đến trong vòng 15 phút cuối, show code, nhận cơm.
7. Quán đóng cửa đúng 16h, không còn đồ thừa.

**Screens:** 2.2.7 → 2.2.8 → 2.1.1 (sort expiring) → 2.4.2
**Gaps:** J-08 (FCM push chưa có — I4-1); receivers chỉ thấy bài nếu đang mở app

---

### Journey 13: Mái ấm cần đồ gấp — bulk request

> Thiên tai, mái ấm cần 50 bộ quần áo trong 48 giờ. Cần nhiều givers cùng contribute.

**Personas:** Đức (Org admin, Mái Ấm Thiên Tâm) · Nhiều givers

**Diễn biến:**

1. Sau đợt lũ, mái ấm tiếp nhận thêm 20 trẻ. Đức cần gấp: quần áo, chăn màn, đồ dùng cá nhân.
2. Đức không thể claim từng post một — cần givers chủ động tặng.
3. Đức post thông báo trên profile org: *"Mái Ấm Thiên Tâm đang cần gấp: quần áo trẻ em size 4–10, chăn, bàn chải. Liên hệ anh Đức."* (hiện chưa có tính năng "request" — chỉ có givers post offer)
4. Givers thấy org profile của Mái Ấm, chủ động nhắn tin Đức hoặc đăng item với note "Dành cho Mái Ấm Thiên Tâm".
5. Các tình nguyện viên (Lan và 2 người khác) có trong org đi nhận đồ tại nhiều địa điểm khác nhau.
6. Đức track qua dashboard org: đã nhận được gì, còn thiếu gì.

**Screens:** 2.3.2 → 2.1.3a → 2.4.2
**Gaps:** Chưa có tính năng "Org đăng request cần nhận đồ" — hiện chỉ givers mới post được

---

### Journey 14: Tặng theo mùa — đầu năm học

> Tháng 8, cả cộng đồng cùng tặng sách, đồ dùng học tập. Thanks trở thành điểm kết nối.

**Personas:** Nhiều givers (phụ huynh, học sinh cũ) · Nhiều receivers (học sinh, sinh viên, mái ấm)

**Diễn biến:**

1. Giữa tháng 8, phụ huynh dọn sách cũ sau kỳ thi. Feed Thanks tràn ngập sách giáo khoa, đồ dùng học tập.
2. Một nhóm phụ huynh cùng trường cùng nhau đăng: ai có sách lớp mấy thì post lớp đó.
3. Sinh viên, học sinh nghèo browse, filter "Books", sort "Gần nhất". Claim theo nhu cầu.
4. Mái Ấm Thiên Tâm claim 5 bộ sách lớp 6 cho 5 trẻ vừa vào lớp 6.
5. Cuối tháng 8, Thanks có spike lớn về số posts và claims. Leaderboard tháng 8 thay đổi mạnh.
6. Một số givers không dùng app nhưng nghe bạn kể, tải xuống và đăng ký lần đầu trong đợt này.

**Screens:** 2.1.1 → 2.4.1 → 2.4.2 → 2.1.2
**Gaps:** Không có tính năng "seasonal campaign" hay highlight theo chủ đề; A-10/11 leaderboard filters

---

## Tổng quan gaps nổi bật qua các journeys

| Gap | Journey liên quan | Task |
|-----|------------------|------|
| Invite model (business + org members) | 5, 6 | B-new-8→12 (backend), F-new-4/5 (Flutter) |
| Claim dưới danh nghĩa org | 6 | E-10 (scenario), F-new-3 (Flutter) |
| `POST /claims/:id/thanks` (thank-you note) | 1 | B-new-1, F-new-1 |
| Mark no-show | 9 | D-07 / K-08 (scenario), B-new-6 (backend), F-new-2 (Flutter) |
| Leaderboard `giver_type` + `period` | 2, 7 | B-new-2 |
| FCM push notifications | 12 | I4-1 |
| Org đăng "request cần nhận" | 13 | E-12 (scenario), B-new-13 (post-MVP) |
| Re-post gợi ý sau khi item expires | 10 | K-15 (scenario), F-new-7 (Flutter) |
| "Similar items" recommendation | 11 | A-13 (scenario), F-new-6 (Flutter) |
