-- =============================================================
-- seed/dev_seed.sql — Prototype-quality connected seed data
-- =============================================================
-- All entities match the Thanks app prototype screens (27 HTML files).
-- Source of truth: idea_to_static_html/
--
-- Dev user (the "logged-in" test account for local dev):
--   name: Nguyễn Minh Hoàng  (displays as "Minh H.")
--   auth_providers: provider=google, provider_user_id='dev-user-001'
--   UUID: 00000000-0000-0000-0000-000000000001
--   Active confirmed claim (receiver): Bento Cooky, pickup_code=A4B7C2
--   Owns businesses: Bento Cooky (verified), Gam Coffee (verified),
--                    Phở Hồng (pending), Ngon Quán (action_needed)
--
-- UUID schemes:
--   users         00000000-0000-0000-0000-0000000000XX  (01-17)
--   businesses    00000000-0000-0000-0001-0000000000XX  (01-06)
--   organizations 00000000-0000-0000-0002-0000000000XX  (01-03)
--   posts         00000000-0000-0000-0003-0000000000XX  (01-23)
--   auth_providers 00000000-0000-0000-0010-0000000000XX (01-17)
--   claims        00000000-0000-0000-0005-0000000000XX  (01-50)
--   messages      00000000-0000-0000-0006-0000000000XX
--   ratings       00000000-0000-0000-0007-0000000000XX
--   thanks        00000000-0000-0000-0008-0000000000XX
--   notifications 00000000-0000-0000-0009-0000000000XX
--
-- ⚠️  DESTRUCTIVE: wipes all application tables before inserting.
--     Only run on local dev DB. Never on staging/production.
--
-- Run (from thanks-backend/):
--   make seed-dev
-- =============================================================

BEGIN;

-- ── 0. Wipe all application data ────────────────────────────────────────────
TRUNCATE TABLE
    invites, org_members, business_members,
    notifications, thanks, ratings, messages,
    claims, post_images, post_schedules, posts,
    organizations, businesses,
    auth_providers, sessions, device_tokens,
    revoked_tokens, users
CASCADE;

-- ── 1. USERS (17) ────────────────────────────────────────────────────────────
-- Leaderboard personal givers: Minh H. #3 (7 items), Linh H. #5 (5),
-- Phuong L. #6 (4), Khanh L. #7 (4), Huyen P. #9 (3), Khanh V. #10 (2).
INSERT INTO users (id, name, phone, email, avatar_url, bio,
                   role_type, giver_type, receiver_type,
                   city, is_verified, rating_avg, rating_count,
                   created_at, updated_at)
VALUES
  -- 1. Nguyễn Minh Hoàng — Dev User, displays "Minh H."
  --    Logged-in account. Owns Bento Cooky + Gam Coffee. Personal giver rank #3.
  ('00000000-0000-0000-0000-000000000001',
   'Nguyễn Minh Hoàng', NULL, 'm@gmail.com',
   'https://i.pravatar.cc/150?img=68',
   'Thích chia sẻ đồ dùng còn tốt. P. Cát Lái, TP.HCM.',
   'both', 'personal', 'personal',
   'Hồ Chí Minh', true, 4.90, 12,
   NOW() - INTERVAL '120 days', NOW()),

  -- 2. Trần Minh Nam — displays "Nam T.", receiver, admin Mái Ấm Hoa Sen
  ('00000000-0000-0000-0000-000000000002',
   'Trần Minh Nam', '0901111102', 'nam.tran@maiam.org',
   'https://i.pravatar.cc/150?img=53',
   'Quản lý Mái Ấm Hoa Sen. P. Bàn Cờ, TP.HCM.',
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', true, 4.80, 6,
   NOW() - INTERVAL '200 days', NOW()),

  -- 3. Lê Thị Linh — displays "Linh H.", personal giver, leaderboard #5
  ('00000000-0000-0000-0000-000000000003',
   'Lê Thị Linh', '0901111103', 'linh.le@gmail.com',
   'https://i.pravatar.cc/150?img=47',
   'Hay cho sách và đồ dùng học tập.',
   'giver', 'personal', NULL,
   'Hồ Chí Minh', true, 4.90, 12,
   NOW() - INTERVAL '180 days', NOW()),

  -- 4. Phương Lê — displays "Phuong L.", personal giver, leaderboard #6
  ('00000000-0000-0000-0000-000000000004',
   'Phương Lê', '0901111104', 'phuong.le@gmail.com',
   'https://i.pravatar.cc/150?img=23',
   'Hay chia sẻ đồ gia dụng và quần áo còn mới.',
   'giver', 'personal', NULL,
   'Hồ Chí Minh', true, 4.80, 8,
   NOW() - INTERVAL '160 days', NOW()),

  -- 5. Khánh Lý — displays "Khanh L.", personal giver, leaderboard #7
  ('00000000-0000-0000-0000-000000000005',
   'Khánh Lý', '0901111105', 'khanh.ly@gmail.com',
   'https://i.pravatar.cc/150?img=60',
   NULL,
   'giver', 'personal', NULL,
   'Hồ Chí Minh', false, 4.90, 6,
   NOW() - INTERVAL '140 days', NOW()),

  -- 6. Huyền Phạm — displays "Huyen P.", personal giver, leaderboard #9
  ('00000000-0000-0000-0000-000000000006',
   'Huyền Phạm', '0901111106', 'huyen.pham@gmail.com',
   'https://i.pravatar.cc/150?img=32',
   NULL,
   'giver', 'personal', NULL,
   'Hồ Chí Minh', false, 4.70, 4,
   NOW() - INTERVAL '100 days', NOW()),

  -- 7. Khánh Vũ — displays "Khanh V.", personal giver, leaderboard #10
  ('00000000-0000-0000-0000-000000000007',
   'Khánh Vũ', '0901111107', 'khanh.vu@gmail.com',
   'https://i.pravatar.cc/150?img=18',
   NULL,
   'giver', 'personal', NULL,
   'Hồ Chí Minh', false, 4.60, 3,
   NOW() - INTERVAL '80 days', NOW()),

  -- 8. Linh Phạm — displays "Linh P.", receiver, ★4.7, 4 past claims
  --    Claimant on Lacoste T-shirts (P01) + Bento Cooky (P06)
  ('00000000-0000-0000-0000-000000000008',
   'Linh Phạm', '0901111108', NULL,
   'https://i.pravatar.cc/150?img=44',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.70, 4,
   NOW() - INTERVAL '60 days', NOW()),

  -- 9. Thảo Nguyễn — displays "Thao", receiver
  --    Claimant on Lacoste T-shirts (P01)
  ('00000000-0000-0000-0000-000000000009',
   'Thảo Nguyễn', '0901111109', NULL,
   'https://i.pravatar.cc/150?img=29',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.50, 2,
   NOW() - INTERVAL '45 days', NOW()),

  -- 10. Phương Võ — displays "Phuong V.", receiver
  --     Claimant on Gam Coffee Iced Lattes (P12), messaging "On my way"
  ('00000000-0000-0000-0000-000000000010',
   'Phương Võ', '0901111110', NULL,
   'https://i.pravatar.cc/150?img=36',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.60, 3,
   NOW() - INTERVAL '30 days', NOW()),

  -- 11. An Hoàng — displays "An H.", receiver, ★4.6, 2 past claims
  --     Claimant on Mixed soups (P07) + Bento Cooky (P06, picked_up)
  ('00000000-0000-0000-0000-000000000011',
   'An Hoàng', '0901111111', NULL,
   'https://i.pravatar.cc/150?img=15',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.60, 2,
   NOW() - INTERVAL '50 days', NOW()),

  -- 12. Thúy Nguyễn — displays "Thuy N.", receiver, ★4.9, 6 past claims
  --     Claimant on Bento Cooky (P06)
  ('00000000-0000-0000-0000-000000000012',
   'Thúy Nguyễn', '0901111112', NULL,
   'https://i.pravatar.cc/150?img=25',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.90, 6,
   NOW() - INTERVAL '90 days', NOW()),

  -- 13. Phong Vũ — displays "Phong V.", receiver, ★4.8, 3 past claims
  --     Claimant on Bento Cooky (P06, picked_up)
  ('00000000-0000-0000-0000-000000000013',
   'Phong Vũ', '0901111113', NULL,
   'https://i.pravatar.cc/150?img=57',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 4.80, 3,
   NOW() - INTERVAL '70 days', NOW()),

  -- 14. Đức Nguyễn — displays "Duc N.", giver+receiver
  --     Giver for P32 (áo sơ mi, home feed); receiver/claimant elsewhere
  ('00000000-0000-0000-0000-000000000014',
   'Đức Nguyễn', '0901111114', NULL,
   'https://i.pravatar.cc/150?img=11',
   NULL,
   'both', 'personal', 'personal',
   'Hồ Chí Minh', false, 4.80, 5,
   NOW() - INTERVAL '110 days', NOW()),

  -- 15. Linh Nguyễn — displays "Linh N.", receiver
  --     Rated Minh H. ★5 for xe đẩy em bé (baby stroller)
  ('00000000-0000-0000-0000-000000000015',
   'Linh Nguyễn', '0901111115', NULL,
   'https://i.pravatar.cc/150?img=40',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 5.00, 3,
   NOW() - INTERVAL '75 days', NOW()),

  -- 16. Quốc Đạt — owner of Tous Les Jours (leaderboard #4, 6 items ★5.0)
  ('00000000-0000-0000-0000-000000000016',
   'Quốc Đạt', '0901111116', 'dat@touslsjours.vn',
   'https://i.pravatar.cc/150?img=63',
   NULL,
   'giver', 'business', NULL,
   'Hồ Chí Minh', true, 5.00, 7,
   NOW() - INTERVAL '300 days', NOW()),

  -- 17. Tất Thành — owner of Pizza 4P's (leaderboard #8, 4 items ★4.8)
  ('00000000-0000-0000-0000-000000000017',
   'Tất Thành', '0901111117', 'thanh@pizza4ps.vn',
   'https://i.pravatar.cc/150?img=71',
   NULL,
   'giver', 'business', NULL,
   'Hồ Chí Minh', true, 4.80, 5,
   NOW() - INTERVAL '250 days', NOW());

-- ── 2. BUSINESSES (6) ────────────────────────────────────────────────────────
-- Minh H. owns: Bento Cooky (verified), Gam Coffee (verified),
--               Phở Hồng (pending), Ngon Quán (action_needed)
-- Screens: 2_1_4b, 2_2_1, 2_2_5, leaderboard #1/#2/#4/#8
INSERT INTO businesses (id, owner_user_id, name, category,
                        logo_url, phone, description,
                        address, latitude, longitude, city,
                        verification_status, verified_at, is_active,
                        created_at, updated_at)
VALUES
  -- B1. Bento Cooky — leaderboard #1, 62 items given, ★4.9
  ('00000000-0000-0000-0001-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'Bento Cooky', 'restaurant',
   'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=200&q=80&auto=format&fit=crop',
   '0281111001',
   'Nhà hàng bento tươi ngon. Tặng bento thừa sau giờ cao điểm cho người cần. 248 Lê Lai, P. Sài Gòn, Q.1.',
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   10.7730, 106.6960, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '200 days', true,
   NOW() - INTERVAL '210 days', NOW()),

  -- B2. Gam Coffee — leaderboard #2, 44 items given, ★4.9
  ('00000000-0000-0000-0001-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Gam Coffee', 'cafe',
   'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&q=80&auto=format&fit=crop',
   '0281111002',
   'Quán cà phê specialty. Tặng cà phê ngày hôm trước cho sáng hôm sau. 15 Nguyễn Huệ, P. Sài Gòn, Q.1.',
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   10.7769, 106.7039, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '180 days', true,
   NOW() - INTERVAL '190 days', NOW()),

  -- B3. Tous Les Jours — leaderboard #4, 6 items ★5.0
  ('00000000-0000-0000-0001-000000000003',
   '00000000-0000-0000-0000-000000000016',
   'Tous Les Jours', 'bakery',
   'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80&auto=format&fit=crop',
   '0281111003',
   'Chuỗi bánh mì và bánh ngọt phong cách Pháp–Hàn. Tặng bánh sắp hết hạn cuối ngày.',
   '55 Lê Thánh Tôn, Phường Bến Nghé, Quận 1, TP.HCM',
   10.7773, 106.7030, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '250 days', true,
   NOW() - INTERVAL '260 days', NOW()),

  -- B4. Pizza 4P's — leaderboard #8, 4 items ★4.8
  ('00000000-0000-0000-0001-000000000004',
   '00000000-0000-0000-0000-000000000017',
   'Pizza 4P''s', 'restaurant',
   'https://picsum.photos/seed/pizza4ps/200/200',
   '0281111004',
   'Nhà hàng pizza nổi tiếng. Tặng pizza còn dư cuối ca tối.',
   '8 Cao Bá Quát, Phường Bến Nghé, Quận 1, TP.HCM',
   10.7760, 106.7010, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '300 days', true,
   NOW() - INTERVAL '310 days', NOW()),

  -- B5. Phở Hồng — pending (Minh H. đang chờ xét duyệt, screen 2_2_5)
  ('00000000-0000-0000-0001-000000000005',
   '00000000-0000-0000-0000-000000000001',
   'Phở Hồng', 'restaurant',
   'https://picsum.photos/seed/pho_hong/200/200',
   '0901000005',
   'Quán phở truyền thống. Muốn tặng phở thừa mỗi sáng.',
   '123 Lê Lợi, Phường Sài Gòn, Quận 1, TP.HCM',
   10.7755, 106.6997, 'Hồ Chí Minh',
   'pending_review', NULL, true,
   NOW() - INTERVAL '5 days', NOW()),

  -- B6. Ngon Quán — action_needed / rejected (Minh H., screen 2_2_5)
  ('00000000-0000-0000-0001-000000000006',
   '00000000-0000-0000-0000-000000000001',
   'Ngon Quán', 'restaurant',
   'https://picsum.photos/seed/ngon_quan/200/200',
   '0901000006',
   'Quán cơm bình dân.',
   '88 Hai Bà Trưng, Phường Bàn Cờ, Quận 3, TP.HCM',
   10.7810, 106.6950, 'Hồ Chí Minh',
   'action_needed', NULL, false,
   NOW() - INTERVAL '30 days', NOW() - INTERVAL '20 days');

-- ── 3. ORGANIZATIONS (3) ─────────────────────────────────────────────────────
-- Nam T. (0002) quản lý cả 3. Screens: 2_3_2, 2_3_3.
INSERT INTO organizations (id, owner_user_id, name, category,
                           logo_url, phone, description, address,
                           contact_person_name, latitude, longitude, city,
                           verification_status, verified_at, is_active,
                           created_at, updated_at)
VALUES
  -- O1. Mái Ấm Hoa Sen — verified orphanage, 5 deliveries ~38 people
  ('00000000-0000-0000-0002-000000000001',
   '00000000-0000-0000-0000-000000000002',
   'Mái Ấm Hoa Sen', 'social',
   'https://picsum.photos/seed/maiam_hoasen/200/200',
   '0284222001',
   'Mái ấm nuôi dưỡng 30 trẻ em từ 4–16 tuổi, hoạt động từ 2009 dưới sự bảo trợ của Giáo xứ Tân Định. 4 tình nguyện viên thường trực.',
   '34 Hai Bà Trưng, Phường Tân Định, Quận 1, TP.HCM',
   'Trần Minh Nam',
   10.7850, 106.6940, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '150 days', true,
   NOW() - INTERVAL '160 days', NOW()),

  -- O2. Saigon Animal Rescue — pending (submitted 3 days ago)
  ('00000000-0000-0000-0002-000000000002',
   '00000000-0000-0000-0000-000000000002',
   'Saigon Animal Rescue', 'other',
   'https://picsum.photos/seed/sar/200/200',
   '0901222002',
   'Tổ chức cứu trợ và tái định cư động vật bị bỏ rơi tại TP.HCM.',
   '45/2 Trần Xuân Soạn, Phường Tân Mỹ, Quận 7, TP.HCM',
   'Trần Minh Nam',
   10.7370, 106.7100, 'Hồ Chí Minh',
   'pending_review', NULL, true,
   NOW() - INTERVAL '3 days', NOW()),

  -- O3. Lá Lành Group — action_needed (screen 2_3_3: documents required)
  ('00000000-0000-0000-0002-000000000003',
   '00000000-0000-0000-0000-000000000002',
   'Lá Lành Group', 'social',
   'https://picsum.photos/seed/lalanh/200/200',
   '0901222003',
   'Nhóm hỗ trợ tương trợ cộng đồng tại TP.HCM.',
   NULL,
   'Trần Minh Nam',
   NULL, NULL, 'Hồ Chí Minh',
   'action_needed', NULL, false,
   NOW() - INTERVAL '14 days', NOW());

-- ── 4. AUTH PROVIDERS (17) ───────────────────────────────────────────────────
INSERT INTO auth_providers (id, user_id, provider, provider_user_id, email, created_at)
VALUES
  ('00000000-0000-0000-0010-000000000001','00000000-0000-0000-0000-000000000001','google','dev-user-001','m@gmail.com',NOW()-INTERVAL '120 days'),
  ('00000000-0000-0000-0010-000000000002','00000000-0000-0000-0000-000000000002','google','seed-nam-002','nam.tran@maiam.org',NOW()-INTERVAL '200 days'),
  ('00000000-0000-0000-0010-000000000003','00000000-0000-0000-0000-000000000003','google','seed-linh-003','linh.le@gmail.com',NOW()-INTERVAL '180 days'),
  ('00000000-0000-0000-0010-000000000004','00000000-0000-0000-0000-000000000004','google','seed-phuong-004','phuong.le@gmail.com',NOW()-INTERVAL '160 days'),
  ('00000000-0000-0000-0010-000000000005','00000000-0000-0000-0000-000000000005','google','seed-khanh-005','khanh.ly@gmail.com',NOW()-INTERVAL '140 days'),
  ('00000000-0000-0000-0010-000000000006','00000000-0000-0000-0000-000000000006','google','seed-huyen-006','huyen.pham@gmail.com',NOW()-INTERVAL '100 days'),
  ('00000000-0000-0000-0010-000000000007','00000000-0000-0000-0000-000000000007','google','seed-khanhv-007','khanh.vu@gmail.com',NOW()-INTERVAL '80 days'),
  -- Receivers: phone_otp primary + google alias for dev login sheet
  ('00000000-0000-0000-0010-000000000008','00000000-0000-0000-0000-000000000008','phone_otp','0901111108',NULL,NOW()-INTERVAL '60 days'),
  ('00000000-0000-0000-0010-000000000108','00000000-0000-0000-0000-000000000008','google','seed-linhp-008',NULL,NOW()-INTERVAL '60 days'),
  ('00000000-0000-0000-0010-000000000009','00000000-0000-0000-0000-000000000009','phone_otp','0901111109',NULL,NOW()-INTERVAL '45 days'),
  ('00000000-0000-0000-0010-000000000010','00000000-0000-0000-0000-000000000010','phone_otp','0901111110',NULL,NOW()-INTERVAL '30 days'),
  ('00000000-0000-0000-0010-000000000110','00000000-0000-0000-0000-000000000010','google','seed-phuongv-010',NULL,NOW()-INTERVAL '30 days'),
  ('00000000-0000-0000-0010-000000000011','00000000-0000-0000-0000-000000000011','phone_otp','0901111111',NULL,NOW()-INTERVAL '50 days'),
  ('00000000-0000-0000-0010-000000000111','00000000-0000-0000-0000-000000000011','google','seed-anh-011',NULL,NOW()-INTERVAL '50 days'),
  ('00000000-0000-0000-0010-000000000012','00000000-0000-0000-0000-000000000012','phone_otp','0901111112',NULL,NOW()-INTERVAL '90 days'),
  ('00000000-0000-0000-0010-000000000013','00000000-0000-0000-0000-000000000013','phone_otp','0901111113',NULL,NOW()-INTERVAL '70 days'),
  ('00000000-0000-0000-0010-000000000014','00000000-0000-0000-0000-000000000014','phone_otp','0901111114',NULL,NOW()-INTERVAL '110 days'),
  ('00000000-0000-0000-0010-000000000015','00000000-0000-0000-0000-000000000015','phone_otp','0901111115',NULL,NOW()-INTERVAL '75 days'),
  ('00000000-0000-0000-0010-000000000016','00000000-0000-0000-0000-000000000016','google','seed-dat-016','dat@touslsjours.vn',NOW()-INTERVAL '300 days'),
  ('00000000-0000-0000-0010-000000000017','00000000-0000-0000-0000-000000000017','google','seed-thanh-017','thanh@pizza4ps.vn',NOW()-INTERVAL '250 days');

-- ── 5. POSTS (23) ────────────────────────────────────────────────────────────
-- P01–P05: Minh H. personal (12 Đường Số 7, P. Cát Lái)
-- P06–P11: Bento Cooky (248 Lê Lai)
-- P12–P14: Gam Coffee (15 Nguyễn Huệ)
-- P15–P16: Tous Les Jours
-- P17:     Pizza 4P's
-- P18:     Linh H. personal
-- P19:     Phuong L. personal
-- P20:     Khanh L. personal
-- P21:     Huyen P. personal
-- P22:     Khanh V. personal
-- P23:     Minh H. personal — past Lacoste (for Duc N. rating)
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES

  -- P01. Lacoste T-shirts (active) — screen 2_2_3, 2_4_1
  ('00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Áo polo Lacoste (đã qua sử dụng)',
   '3 chiếc áo polo Lacoste size M màu navy, trắng và kẻ sọc. Tất cả đã giặt phẳng. Nhận tại nhà, nhắn tin trước.',
   'clothes', 3, 1, NULL,
   (NOW() + INTERVAL '1 day')::date + TIME '14:00',
   (NOW() + INTERVAL '1 day')::date + TIME '18:00',
   NOW() + INTERVAL '10 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Tặng 3 áo polo Lacoste size M, đã giặt sạch, nhận tại P. Cát Lái.',
   NOW() - INTERVAL '2 days', NOW()),

  -- P02. Kemei haircut machine (active) — screen 2_2_3
  ('00000000-0000-0000-0003-000000000002',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Máy cắt tóc Kemei (mới 90%)',
   '5 chiếc máy cắt tóc Kemei KM-1990, dùng 1–2 lần, còn như mới. Tặng thợ tóc hoặc người cần tự cắt. Nhận Thứ 7–CN 14h–18h.',
   'tech', 5, 5, NULL,
   (NOW() + INTERVAL '6 days')::date + TIME '14:00',
   (NOW() + INTERVAL '6 days')::date + TIME '18:00',
   NOW() + INTERVAL '30 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Tặng 5 máy cắt tóc Kemei còn mới tại P. Cát Lái.',
   NOW() - INTERVAL '1 day', NOW()),

  -- P03. Sách kinh doanh (completed) — screen 2_2_3, 2_2_9 (thanks)
  ('00000000-0000-0000-0003-000000000003',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Sách kinh doanh (bộ 8 cuốn)',
   'Bộ 8 cuốn sách kinh doanh, quản trị và marketing. Còn mới 90%. Tặng cho bạn trẻ học kinh doanh hoặc MBA.',
   'books', 8, 6, NULL,
   NOW() - INTERVAL '8 days',
   NOW() - INTERVAL '8 days' + INTERVAL '4 hours',
   NOW() - INTERVAL '5 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'completed', false,
   'Tặng bộ 8 sách kinh doanh, marketing, quản trị tại P. Cát Lái.',
   NOW() - INTERVAL '10 days', NOW() - INTERVAL '5 days'),
  -- (qty_remaining=6 because only 2 people claimed: Phuong L. + Duc N.)

  -- P04. Ghế văn phòng (completed) — screen 2_2_3
  ('00000000-0000-0000-0003-000000000004',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Ghế văn phòng Herman Miller (cũ)',
   'Ghế văn phòng lưng cao, đã dùng 3 năm, còn tốt. Người nhận tự vận chuyển. Nhà ở P. Cát Lái.',
   'furniture', 1, 0, NULL,
   NOW() - INTERVAL '17 days',
   NOW() - INTERVAL '17 days' + INTERVAL '4 hours',
   NOW() - INTERVAL '14 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '20 days', NOW() - INTERVAL '14 days'),

  -- P05. Xe đẩy em bé (completed) — screen 2_2_3, 2_2_9 (Linh N. thanks)
  ('00000000-0000-0000-0003-000000000005',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Xe đẩy em bé (baby stroller)',
   'Xe đẩy Aprica màu xám, con đã lớn nên không dùng nữa. Còn rất tốt, đầy đủ phụ kiện. Tặng gia đình có em bé.',
   'other', 1, 0, NULL,
   NOW() - INTERVAL '10 days',
   NOW() - INTERVAL '10 days' + INTERVAL '4 hours',
   NOW() - INTERVAL '7 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '12 days', NOW() - INTERVAL '7 days'),

  -- P06. Bento Cơm Gà 20 (active, closing in ~2h30m) — screen 2_2_4, 2_4_3, 2_1_3a/b
  ('00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   '20 Bento Cơm Gà',
   'Hôm nay Bento Cooky còn 20 phần bento cơm gà chất lượng. Lấy theo suất, mỗi người 1 phần. Đến lấy trực tiếp tại quán.',
   'food', 20, 6, 1,
   NOW()::date + TIME '10:00',
   NOW()::date + TIME '18:00',
   NOW() + INTERVAL '2 hours 30 minutes',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Bento Cooky tặng 20 phần bento cơm gà, mỗi người 1 phần, hôm nay tại Q.1.',
   NOW() - INTERVAL '3 hours', NOW()),

  -- P07. Súp hỗn hợp 4 (active, hôm nay 17h) — screen 2_1_1, 2_4_3
  ('00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Súp hỗn hợp (4 phần)',
   'Còn 4 phần súp hỗn hợp bò và rau củ. Đến lấy trước 17h hôm nay.',
   'food', 4, 1, 1,
   NOW()::date + TIME '11:00',
   NOW()::date + TIME '17:00',
   NOW()::date + TIME '17:00',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Bento Cooky tặng 4 phần súp hỗn hợp, nhận trước 17h hôm nay.',
   NOW() - INTERVAL '2 hours', NOW()),

  -- P08. Bento Bò 15 (completed, hôm qua) — screen 2_2_4
  ('00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   '15 Bento Bò Nướng',
   '15 phần bento bò nướng còn dư sau ca tối hôm qua.',
   'food', 15, 0, 1,
   NOW() - INTERVAL '1 day' + TIME '18:00',
   NOW() - INTERVAL '1 day' + TIME '21:00',
   NOW() - INTERVAL '20 hours',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '2 hours', NOW() - INTERVAL '20 hours'),

  -- P09. Pizza 8 lát (completed, 2 days ago) — screen 2_2_4
  ('00000000-0000-0000-0003-000000000009',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Pizza 8 lát (hết ca)',
   '8 lát pizza còn lại sau ca tối. Tặng miễn phí.',
   'food', 8, 0, NULL,
   NOW() - INTERVAL '2 days' + TIME '21:00',
   NOW() - INTERVAL '2 days' + TIME '22:00',
   NOW() - INTERVAL '2 days' - INTERVAL '1 hour',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '2 days' - INTERVAL '3 hours', NOW() - INTERVAL '2 days' - INTERVAL '1 hour'),

  -- P10. Bánh mini 12 cái (completed, 3 days ago) — screen 2_2_4
  ('00000000-0000-0000-0003-000000000010',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Bánh mini tổng hợp (12 cái)',
   '12 bánh mini các loại: mousse, tiramisu, matcha. Hết hạn hôm nay, tặng trước 20h.',
   'food', 12, 0, NULL,
   NOW() - INTERVAL '3 days' + TIME '17:00',
   NOW() - INTERVAL '3 days' + TIME '20:00',
   NOW() - INTERVAL '3 days',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '3 days' - INTERVAL '4 hours', NOW() - INTERVAL '3 days'),

  -- P11. Nước cam ép 13 ly (completed, 5 days ago) — makes up Bento Cooky 62 total
  ('00000000-0000-0000-0003-000000000011',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Nước cam ép tươi (13 ly)',
   '13 ly nước cam ép tươi còn dư sau buổi chiều. Tặng trước 18h.',
   'food', 13, 0, NULL,
   NOW() - INTERVAL '5 days' + TIME '16:00',
   NOW() - INTERVAL '5 days' + TIME '18:00',
   NOW() - INTERVAL '5 days',
   10.7730, 106.6960,
   '248 Lê Lai, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '5 days' - INTERVAL '3 hours', NOW() - INTERVAL '5 days'),

  -- P12. Iced lattes 8 ly (active) — Gam Coffee, screen 2_1_3a/b (Phuong V. messaging)
  ('00000000-0000-0000-0003-000000000012',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Iced latte (8 ly)',
   '8 ly iced latte hôm nay pha thừa. Uống ngon nhất trong 2 giờ. Ghé quán lấy trực tiếp.',
   'food', 8, 4, 1,
   NOW()::date + TIME '14:00',
   NOW()::date + TIME '17:00',
   NOW()::date + TIME '17:00',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Gam Coffee tặng 8 ly iced latte thừa, lấy trực tiếp tại quán Q.1.',
   NOW() - INTERVAL '1 hour', NOW()),

  -- P13. Cà phê buổi sáng 30 ly (completed) — Gam Coffee leaderboard count
  ('00000000-0000-0000-0003-000000000013',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Cà phê sáng (30 ly)',
   '30 ly cà phê đen và sữa từ hôm qua, tặng buổi sáng sớm cho người đi làm sớm.',
   'food', 30, 0, NULL,
   NOW() - INTERVAL '1 day' + TIME '06:00',
   NOW() - INTERVAL '1 day' + TIME '08:00',
   NOW() - INTERVAL '23 hours',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '5 hours', NOW() - INTERVAL '23 hours'),

  -- P14. Cold brew 10 chai (completed) — Gam Coffee leaderboard count
  ('00000000-0000-0000-0003-000000000014',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Cold brew (10 chai)',
   '10 chai cold brew 500ml ủ từ hôm qua, chưa kịp bán. Hạn dùng hôm nay.',
   'food', 10, 0, NULL,
   NOW() - INTERVAL '2 days' + TIME '09:00',
   NOW() - INTERVAL '2 days' + TIME '12:00',
   NOW() - INTERVAL '2 days',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '2 days' - INTERVAL '4 hours', NOW() - INTERVAL '2 days'),

  -- P15. Bánh mì Pháp 2 ổ (completed) — Tous Les Jours, receiver inbox Minh H. ★5
  ('00000000-0000-0000-0003-000000000015',
   '00000000-0000-0000-0000-000000000016',
   '00000000-0000-0000-0001-000000000003',
   '2 ổ bánh mì Pháp (Baguette)',
   '2 ổ bánh mì Pháp cuối ngày, còn giòn. Tặng trước 20h.',
   'food', 2, 0, NULL,
   NOW() - INTERVAL '4 days' + TIME '18:00',
   NOW() - INTERVAL '4 days' + TIME '20:00',
   NOW() - INTERVAL '4 days',
   10.7773, 106.7030,
   '55 Lê Thánh Tôn, Phường Bến Nghé, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '4 days' - INTERVAL '3 hours', NOW() - INTERVAL '4 days'),

  -- P16. Bánh croissant 4 cái (completed) — Tous Les Jours leaderboard 6 total
  ('00000000-0000-0000-0003-000000000016',
   '00000000-0000-0000-0000-000000000016',
   '00000000-0000-0000-0001-000000000003',
   'Croissant bơ (4 cái)',
   '4 bánh croissant bơ cuối ngày, còn thơm giòn.',
   'food', 4, 0, NULL,
   NOW() - INTERVAL '6 days' + TIME '18:00',
   NOW() - INTERVAL '6 days' + TIME '20:00',
   NOW() - INTERVAL '6 days',
   10.7773, 106.7030,
   '55 Lê Thánh Tôn, Phường Bến Nghé, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '6 days' - INTERVAL '3 hours', NOW() - INTERVAL '6 days'),

  -- P17. Pizza 4 lát (completed) — Pizza 4P's, leaderboard #8 4 items
  ('00000000-0000-0000-0003-000000000017',
   '00000000-0000-0000-0000-000000000017',
   '00000000-0000-0000-0001-000000000004',
   'Pizza (4 lát còn lại)',
   '4 lát pizza Margherita và Quattro Formaggi còn dư cuối ca tối.',
   'food', 4, 0, NULL,
   NOW() - INTERVAL '3 days' + TIME '21:30',
   NOW() - INTERVAL '3 days' + TIME '22:30',
   NOW() - INTERVAL '3 days',
   10.7760, 106.7010,
   '8 Cao Bá Quát, Phường Bến Nghé, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '3 days' - INTERVAL '4 hours', NOW() - INTERVAL '3 days'),

  -- P18. Sách thiếu nhi 5 cuốn (completed) — Linh H., receiver inbox Minh H. ★4
  ('00000000-0000-0000-0003-000000000018',
   '00000000-0000-0000-0000-000000000003', NULL,
   'Sách thiếu nhi (5 cuốn)',
   '5 cuốn sách thiếu nhi: Doraemon, Thám tử lừng danh Conan, Wonders. Còn mới. Tặng bé 6–12 tuổi.',
   'books', 5, 0, NULL,
   NOW() - INTERVAL '7 days' + TIME '09:00',
   NOW() - INTERVAL '7 days' + TIME '12:00',
   NOW() - INTERVAL '5 days',
   10.7820, 106.6930,
   'Quận Bình Thạnh, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '9 days', NOW() - INTERVAL '5 days'),

  -- P19. Đồ gia dụng 4 món (completed) — Phuong L., leaderboard #6 4 items
  ('00000000-0000-0000-0003-000000000019',
   '00000000-0000-0000-0000-000000000004', NULL,
   'Đồ gia dụng (4 món)',
   'Nồi cơm điện, quạt bàn, bàn ủi, bình đun nước. Dọn nhà cho đi hết. Còn dùng tốt.',
   'furniture', 4, 0, NULL,
   NOW() - INTERVAL '14 days' + TIME '08:00',
   NOW() - INTERVAL '14 days' + TIME '12:00',
   NOW() - INTERVAL '12 days',
   10.7780, 106.6970,
   'Quận 3, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '16 days', NOW() - INTERVAL '12 days'),

  -- P20. Quần áo cũ 4 bộ (completed) — Khanh L., leaderboard #7 4 items
  ('00000000-0000-0000-0003-000000000020',
   '00000000-0000-0000-0000-000000000005', NULL,
   'Quần áo nam size M (4 bộ)',
   '4 bộ quần áo nam size M, đã giặt. Tặng bạn trẻ cần.',
   'clothes', 4, 0, NULL,
   NOW() - INTERVAL '20 days' + TIME '08:00',
   NOW() - INTERVAL '20 days' + TIME '12:00',
   NOW() - INTERVAL '18 days',
   10.7760, 106.6980,
   'Quận Tân Bình, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '22 days', NOW() - INTERVAL '18 days'),

  -- P21. Đồ dùng học tập 3 món (completed) — Huyen P., leaderboard #9 3 items
  ('00000000-0000-0000-0003-000000000021',
   '00000000-0000-0000-0000-000000000006', NULL,
   'Đồ dùng học tập (3 bộ)',
   'Ba lô, hộp bút, vở 200 trang. Tặng học sinh cấp 2 cần.',
   'other', 3, 0, NULL,
   NOW() - INTERVAL '18 days' + TIME '07:00',
   NOW() - INTERVAL '18 days' + TIME '11:00',
   NOW() - INTERVAL '16 days',
   10.7750, 106.6960,
   'Quận Gò Vấp, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '20 days', NOW() - INTERVAL '16 days'),

  -- P22. Sách văn học 2 cuốn (completed) — Khanh V., leaderboard #10 2 items
  ('00000000-0000-0000-0003-000000000022',
   '00000000-0000-0000-0000-000000000007', NULL,
   'Sách văn học (2 cuốn)',
   'Nhà Giả Kim và Người Đua Diều. Còn mới 95%.',
   'books', 2, 0, NULL,
   NOW() - INTERVAL '25 days' + TIME '09:00',
   NOW() - INTERVAL '25 days' + TIME '13:00',
   NOW() - INTERVAL '23 days',
   10.7740, 106.6970,
   'Quận Phú Nhuận, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '27 days', NOW() - INTERVAL '23 days'),

  -- P23. Áo polo Lacoste cũ 1 chiếc (completed) — Minh H. personal, Duc N. received
  --     Needed so Duc N. can have a "Lacoste T-shirt" rating in screen 2_2_9
  ('00000000-0000-0000-0003-000000000023',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Áo polo Lacoste cũ (1 chiếc)',
   'Áo polo Lacoste size L màu xanh lá, dùng 2 năm còn đẹp. Tặng người cần.',
   'clothes', 1, 0, NULL,
   NOW() - INTERVAL '3 days' + TIME '14:00',
   NOW() - INTERVAL '3 days' + TIME '18:00',
   NOW() - INTERVAL '1 day',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day');

-- ── 6. POST SCHEDULES ────────────────────────────────────────────────────────
-- P01 Lacoste: Mon (1) + Tue (2), 14:00–18:00
-- P02 Kemei: Sat (6) + Sun (0), 14:00–18:00
-- P06 Bento Cơm Gà: Sat (6) + Sun (0), 10:00–18:00
INSERT INTO post_schedules (post_id, day_of_week, start_time, end_time) VALUES
  ('00000000-0000-0000-0003-000000000001', 1, '14:00', '18:00'),
  ('00000000-0000-0000-0003-000000000001', 2, '14:00', '18:00'),
  ('00000000-0000-0000-0003-000000000002', 6, '14:00', '18:00'),
  ('00000000-0000-0000-0003-000000000002', 0, '14:00', '18:00'),
  ('00000000-0000-0000-0003-000000000006', 6, '10:00', '18:00'),
  ('00000000-0000-0000-0003-000000000006', 0, '10:00', '18:00');

-- ── 8. CLAIMS ─────────────────────────────────────────────────────────────────
-- Leaderboard (SUM claim.quantity WHERE status IN confirmed/picked_up/completed):
--   Bento Cooky  (P06 14+P08 12+P09 8+P10 12+P11 13+P26 1+P27 1+P30 1) = 62  rank #1
--   Gam Coffee   (P12 4+P13 28+P14 10+P28 1+P29 1)                      = 44  rank #2
--   Minh H. personal (P01 2conf+P03 2+P04 1+P05 1+P23 1) = 7  rank #3 (C52 cancelled)
--   Tous Les Jours   (P15 2 + P16 4)                      =  6  rank #4
--   Linh H.          (P18 5)                               =  5  rank #5
--   Phuong L.        (P19 4)                               =  4  rank #6
--   Khanh L.         (P20 4)                               =  4  rank #7
--   Pizza 4P's       (P17 4)                               =  4  rank #8
--   Huyen P.         (P21 3)                               =  3  rank #9
--   Khanh V.         (P22 2)                               =  2  rank #10
--   P07 Mixed soups: 3 PENDING → does not count toward leaderboard
INSERT INTO claims (id, post_id, user_id, organization_id, quantity,
                    pickup_code, status,
                    confirmed_at, picked_up_at, cancelled_at,
                    created_at, updated_at)
VALUES

  -- ── P01: Lacoste T-shirts (2 confirmed, 1 remaining) ──
  -- C01: Linh P. — confirmed, shows in 2_2_3 claimant list
  --     pickup_code='4286' matches prototype 2_4_2 ("4 · 2 · 8 · 6")
  ('00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000008',
   NULL, 1, '4286', 'confirmed',
   NOW() - INTERVAL '20 hours', NULL, NULL,
   NOW() - INTERVAL '1 day', NOW() - INTERVAL '20 hours'),

  -- C02: Thao — confirmed
  ('00000000-0000-0000-0005-000000000002',
   '00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000009',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '12 hours', NULL, NULL,
   NOW() - INTERVAL '14 hours', NOW() - INTERVAL '12 hours'),

  -- ── P03: Sách kinh doanh (3 completed, used by thanks/ratings) ──
  -- C03: Phuong L. — completed, rated ★5 "These books are gold for my MBA prep"
  ('00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0003-000000000003',
   '00000000-0000-0000-0000-000000000004',
   NULL, 1, 'BK4901', 'completed',
   NOW() - INTERVAL '9 days', NOW() - INTERVAL '8 days', NULL,
   NOW() - INTERVAL '10 days', NOW() - INTERVAL '8 days'),

  -- C04: Duc N. — completed, rated ★5 (shows as rating in 2_2_9)
  ('00000000-0000-0000-0005-000000000004',
   '00000000-0000-0000-0003-000000000003',
   '00000000-0000-0000-0000-000000000014',
   NULL, 1, 'BK4902', 'completed',
   NOW() - INTERVAL '9 days', NOW() - INTERVAL '8 days' - INTERVAL '2 hours', NULL,
   NOW() - INTERVAL '10 days', NOW() - INTERVAL '8 days'),

  -- ── P04: Ghế văn phòng (1 completed) ──
  -- C06: Thao — completed, 2 weeks ago
  ('00000000-0000-0000-0005-000000000006',
   '00000000-0000-0000-0003-000000000004',
   '00000000-0000-0000-0000-000000000009',
   NULL, 1, 'CH1401', 'completed',
   NOW() - INTERVAL '19 days', NOW() - INTERVAL '18 days', NULL,
   NOW() - INTERVAL '20 days', NOW() - INTERVAL '18 days'),

  -- ── P05: Xe đẩy em bé (1 completed) ──
  -- C07: Linh N. — completed, rated ★5 "My daughter loves the stroller"
  ('00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0003-000000000005',
   '00000000-0000-0000-0000-000000000015',
   NULL, 1, 'ST0501', 'completed',
   NOW() - INTERVAL '11 days', NOW() - INTERVAL '10 days', NULL,
   NOW() - INTERVAL '12 days', NOW() - INTERVAL '10 days'),

  -- ── P06: Bento Cơm Gà (14 non-pending, 6 remaining) ──
  -- Named claimants from prototype Who's Claimed screen:
  -- C08: Nam T. — confirmed ETA 17h (2m ago in prototype)
  ('00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000002',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '2 minutes', NULL, NULL,
   NOW() - INTERVAL '2 minutes', NOW() - INTERVAL '2 minutes'),

  -- C09: Linh P. — confirmed ETA 18h (12m ago)
  ('00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000008',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '12 minutes', NULL, NULL,
   NOW() - INTERVAL '12 minutes', NOW() - INTERVAL '12 minutes'),

  -- C10: Thuy N. — confirmed ETA 16h (24m ago)
  ('00000000-0000-0000-0005-000000000010',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000012',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '24 minutes', NULL, NULL,
   NOW() - INTERVAL '24 minutes', NOW() - INTERVAL '24 minutes'),

  -- C11: An H. — picked_up (48m ago)
  ('00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000011',
   NULL, 1, 'BT0611', 'picked_up',
   NOW() - INTERVAL '50 minutes', NOW() - INTERVAL '48 minutes', NULL,
   NOW() - INTERVAL '1 hour', NOW() - INTERVAL '48 minutes'),

  -- C12: Phong V. — picked_up (1h ago)
  ('00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000013',
   NULL, 1, 'BT0612', 'picked_up',
   NOW() - INTERVAL '1 hour 5 minutes', NOW() - INTERVAL '1 hour', NULL,
   NOW() - INTERVAL '1 hour 10 minutes', NOW() - INTERVAL '1 hour'),

  -- Anonymous 8 more (to reach 14 total claimed/confirmed, 6 remaining):
  -- C13: Phuong V.
  ('00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000010',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '35 minutes', NULL, NULL,
   NOW() - INTERVAL '40 minutes', NOW() - INTERVAL '35 minutes'),

  -- C14: Khanh V.
  ('00000000-0000-0000-0005-000000000014',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000007',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '45 minutes', NULL, NULL,
   NOW() - INTERVAL '50 minutes', NOW() - INTERVAL '45 minutes'),

  -- C15: Huyen P.
  ('00000000-0000-0000-0005-000000000015',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000006',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '55 minutes', NULL, NULL,
   NOW() - INTERVAL '60 minutes', NOW() - INTERVAL '55 minutes'),

  -- C16: Khanh L.
  ('00000000-0000-0000-0005-000000000016',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000005',
   NULL, 1, 'BT0616', 'picked_up',
   NOW() - INTERVAL '70 minutes', NOW() - INTERVAL '65 minutes', NULL,
   NOW() - INTERVAL '75 minutes', NOW() - INTERVAL '65 minutes'),

  -- C17: Linh H.
  ('00000000-0000-0000-0005-000000000017',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000003',
   NULL, 1, 'BT0617', 'picked_up',
   NOW() - INTERVAL '80 minutes', NOW() - INTERVAL '75 minutes', NULL,
   NOW() - INTERVAL '85 minutes', NOW() - INTERVAL '75 minutes'),

  -- C18: Phuong L.
  ('00000000-0000-0000-0005-000000000018',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000004',
   NULL, 1, 'BT0618', 'picked_up',
   NOW() - INTERVAL '90 minutes', NOW() - INTERVAL '85 minutes', NULL,
   NOW() - INTERVAL '95 minutes', NOW() - INTERVAL '85 minutes'),

  -- C19 (was slot): Duc N. — picked_up
  ('00000000-0000-0000-0005-000000000049',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000014',
   NULL, 1, 'BT0649', 'picked_up',
   NOW() - INTERVAL '90 minutes', NOW() - INTERVAL '85 minutes', NULL,
   NOW() - INTERVAL '95 minutes', NOW() - INTERVAL '85 minutes'),

  -- C50: Linh N. — picked_up
  ('00000000-0000-0000-0005-000000000050',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000015',
   NULL, 1, 'BT0650', 'picked_up',
   NOW() - INTERVAL '100 minutes', NOW() - INTERVAL '95 minutes', NULL,
   NOW() - INTERVAL '105 minutes', NOW() - INTERVAL '95 minutes'),

  -- C19orig: Minh H. (Dev User, receiver) — confirmed, pickup_code=A4B7C2
  --     This is the active claim shown in receiver inbox (2_1_3a) + claim confirmed (2_4_2)
  ('00000000-0000-0000-0005-000000000019',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000001',
   NULL, 1, 'A4B7C2', 'confirmed',
   NOW() - INTERVAL '1 hour', NULL, NULL,
   NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour'),

  -- ── P07: Súp hỗn hợp (3 pending = claimants shown in 2_1_1, none picked up yet) ──
  -- C20: An H. — pending
  ('00000000-0000-0000-0005-000000000020',
   '00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000011',
   NULL, 1, NULL, 'pending',
   NULL, NULL, NULL,
   NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes'),

  -- C21: Huyen P. — pending (avatar "H" in home feed)
  ('00000000-0000-0000-0005-000000000021',
   '00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000006',
   NULL, 1, NULL, 'pending',
   NULL, NULL, NULL,
   NOW() - INTERVAL '25 minutes', NOW() - INTERVAL '25 minutes'),

  -- C22: Phong V. — pending (avatar "P" in home feed)
  ('00000000-0000-0000-0005-000000000022',
   '00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000013',
   NULL, 1, NULL, 'pending',
   NULL, NULL, NULL,
   NOW() - INTERVAL '20 minutes', NOW() - INTERVAL '20 minutes'),

  -- ── P08: Bento Bò 15 (completed, for Bento Cooky leaderboard +15) ──
  -- C23: Nam T. via Mái Ấm Hoa Sen, org claim
  ('00000000-0000-0000-0005-000000000023',
   '00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   5, 'BO0801', 'completed',
   NOW() - INTERVAL '1 day' - INTERVAL '2 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '1 hour', NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '3 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '1 hour'),

  -- C24: Thuy N.
  ('00000000-0000-0000-0005-000000000024',
   '00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000012',
   NULL, 4, 'BO0802', 'completed',
   NOW() - INTERVAL '1 day' - INTERVAL '2 hours 30 minutes',
   NOW() - INTERVAL '1 day' - INTERVAL '1 hour 30 minutes', NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '3 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '1 hour 30 minutes'),

  -- C25: Phong V.
  ('00000000-0000-0000-0005-000000000025',
   '00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000013',
   NULL, 3, 'BO0803', 'completed',
   NOW() - INTERVAL '1 day' - INTERVAL '3 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '2 hours', NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '4 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '2 hours'),

  -- ── P09: Pizza 8 lát (+8 for Bento Cooky leaderboard) ──
  -- C26: Linh P.
  ('00000000-0000-0000-0005-000000000026',
   '00000000-0000-0000-0003-000000000009',
   '00000000-0000-0000-0000-000000000008',
   NULL, 4, 'PZ0901', 'completed',
   NOW() - INTERVAL '2 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '2 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '2 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '2 days' - INTERVAL '30 minutes'),

  -- C27: An H.
  ('00000000-0000-0000-0005-000000000027',
   '00000000-0000-0000-0003-000000000009',
   '00000000-0000-0000-0000-000000000011',
   NULL, 4, 'PZ0902', 'completed',
   NOW() - INTERVAL '2 days' - INTERVAL '1 hour 15 minutes',
   NOW() - INTERVAL '2 days' - INTERVAL '45 minutes', NULL,
   NOW() - INTERVAL '2 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '2 days' - INTERVAL '45 minutes'),

  -- ── P10: Bánh mini 12 cái (+12 for Bento Cooky leaderboard) ──
  -- C28: Thuy N.
  ('00000000-0000-0000-0005-000000000028',
   '00000000-0000-0000-0003-000000000010',
   '00000000-0000-0000-0000-000000000012',
   NULL, 6, 'BM1001', 'completed',
   NOW() - INTERVAL '3 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '3 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '3 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '3 days' - INTERVAL '30 minutes'),

  -- C29: Linh N.
  ('00000000-0000-0000-0005-000000000029',
   '00000000-0000-0000-0003-000000000010',
   '00000000-0000-0000-0000-000000000015',
   NULL, 6, 'BM1002', 'completed',
   NOW() - INTERVAL '3 days' - INTERVAL '1 hour 20 minutes',
   NOW() - INTERVAL '3 days' - INTERVAL '50 minutes', NULL,
   NOW() - INTERVAL '3 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '3 days' - INTERVAL '50 minutes'),

  -- ── P11: Nước cam 13 ly (+13 for Bento Cooky leaderboard) ──
  -- C30: Khanh L. via Mái Ấm Hoa Sen
  ('00000000-0000-0000-0005-000000000030',
   '00000000-0000-0000-0003-000000000011',
   '00000000-0000-0000-0000-000000000005',
   '00000000-0000-0000-0002-000000000001',
   7, 'NC1101', 'completed',
   NOW() - INTERVAL '5 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '5 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '5 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '5 days' - INTERVAL '30 minutes'),

  -- C31: Linh H.
  ('00000000-0000-0000-0005-000000000031',
   '00000000-0000-0000-0003-000000000011',
   '00000000-0000-0000-0000-000000000003',
   NULL, 6, 'NC1102', 'completed',
   NOW() - INTERVAL '5 days' - INTERVAL '1 hour 10 minutes',
   NOW() - INTERVAL '5 days' - INTERVAL '40 minutes', NULL,
   NOW() - INTERVAL '5 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '5 days' - INTERVAL '40 minutes'),

  -- ── P12: Iced lattes 8 ly (4 active, 4 remaining) ──
  -- C32: Phuong V. — confirmed (messaging "On my way, 5 mins out")
  ('00000000-0000-0000-0005-000000000032',
   '00000000-0000-0000-0003-000000000012',
   '00000000-0000-0000-0000-000000000010',
   NULL, 1, NULL, 'confirmed',
   NOW() - INTERVAL '5 minutes', NULL, NULL,
   NOW() - INTERVAL '15 minutes', NOW() - INTERVAL '5 minutes'),

  -- C33: Linh N. — picked_up
  ('00000000-0000-0000-0005-000000000033',
   '00000000-0000-0000-0003-000000000012',
   '00000000-0000-0000-0000-000000000015',
   NULL, 1, 'GA1201', 'picked_up',
   NOW() - INTERVAL '50 minutes', NOW() - INTERVAL '40 minutes', NULL,
   NOW() - INTERVAL '55 minutes', NOW() - INTERVAL '40 minutes'),

  -- C34: Thao — picked_up
  ('00000000-0000-0000-0005-000000000034',
   '00000000-0000-0000-0003-000000000012',
   '00000000-0000-0000-0000-000000000009',
   NULL, 1, 'GA1202', 'picked_up',
   NOW() - INTERVAL '60 minutes', NOW() - INTERVAL '50 minutes', NULL,
   NOW() - INTERVAL '65 minutes', NOW() - INTERVAL '50 minutes'),

  -- C35: Khanh V. — picked_up
  ('00000000-0000-0000-0005-000000000035',
   '00000000-0000-0000-0003-000000000012',
   '00000000-0000-0000-0000-000000000007',
   NULL, 1, 'GA1203', 'picked_up',
   NOW() - INTERVAL '70 minutes', NOW() - INTERVAL '60 minutes', NULL,
   NOW() - INTERVAL '75 minutes', NOW() - INTERVAL '60 minutes'),

  -- ── P13: Cà phê sáng 30 ly (+30 for Gam Coffee leaderboard) ──
  -- C36: Nam T. via org (big org claim)
  ('00000000-0000-0000-0005-000000000036',
   '00000000-0000-0000-0003-000000000013',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   13, 'CF1301', 'completed',
   NOW() - INTERVAL '1 day' - INTERVAL '5 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '4 hours 30 minutes', NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '6 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '4 hours 30 minutes'),

  -- C37: Thao
  ('00000000-0000-0000-0005-000000000037',
   '00000000-0000-0000-0003-000000000013',
   '00000000-0000-0000-0000-000000000009',
   NULL, 15, 'CF1302', 'completed',
   NOW() - INTERVAL '1 day' - INTERVAL '5 hours 20 minutes',
   NOW() - INTERVAL '1 day' - INTERVAL '4 hours 50 minutes', NULL,
   NOW() - INTERVAL '1 day' - INTERVAL '6 hours',
   NOW() - INTERVAL '1 day' - INTERVAL '4 hours 50 minutes'),

  -- ── P14: Cold brew 10 chai (+10 for Gam Coffee leaderboard) ──
  -- C38: Thuy N.
  ('00000000-0000-0000-0005-000000000038',
   '00000000-0000-0000-0003-000000000014',
   '00000000-0000-0000-0000-000000000012',
   NULL, 10, 'CB1401', 'completed',
   NOW() - INTERVAL '2 days' - INTERVAL '3 hours',
   NOW() - INTERVAL '2 days' - INTERVAL '2 hours 30 minutes', NULL,
   NOW() - INTERVAL '2 days' - INTERVAL '4 hours',
   NOW() - INTERVAL '2 days' - INTERVAL '2 hours 30 minutes'),

  -- ── P15: Baguettes Tous Les Jours (Minh H. as receiver — Done in inbox) ──
  -- C39: Minh H. (Dev User) — completed, rated ★5 (screen 2_1_3a)
  ('00000000-0000-0000-0005-000000000039',
   '00000000-0000-0000-0003-000000000015',
   '00000000-0000-0000-0000-000000000001',
   NULL, 2, 'TJ1501', 'completed',
   NOW() - INTERVAL '4 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '4 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '4 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '4 days' - INTERVAL '30 minutes'),

  -- ── P16: Croissant Tous Les Jours ──
  -- C40: Phuong L.
  ('00000000-0000-0000-0005-000000000040',
   '00000000-0000-0000-0003-000000000016',
   '00000000-0000-0000-0000-000000000004',
   NULL, 4, 'TJ1601', 'completed',
   NOW() - INTERVAL '6 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '6 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '6 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '6 days' - INTERVAL '30 minutes'),

  -- ── P17: Pizza 4P's ──
  -- C41: An H.
  ('00000000-0000-0000-0005-000000000041',
   '00000000-0000-0000-0003-000000000017',
   '00000000-0000-0000-0000-000000000011',
   NULL, 4, 'P4P001', 'completed',
   NOW() - INTERVAL '3 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '3 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '3 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '3 days' - INTERVAL '30 minutes'),

  -- ── P18: Sách thiếu nhi Linh H. (Minh H. as receiver — Done in inbox) ──
  -- C42: Minh H. (Dev User) — completed, rated ★4 (screen 2_1_3a)
  ('00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0003-000000000018',
   '00000000-0000-0000-0000-000000000001',
   NULL, 5, 'LH1801', 'completed',
   NOW() - INTERVAL '7 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '7 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '7 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '7 days' - INTERVAL '30 minutes'),

  -- ── P19: Đồ gia dụng Phuong L. ──
  -- C43: Nam T.
  ('00000000-0000-0000-0005-000000000043',
   '00000000-0000-0000-0003-000000000019',
   '00000000-0000-0000-0000-000000000002',
   NULL, 4, 'PL1901', 'completed',
   NOW() - INTERVAL '14 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '14 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '14 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '14 days' - INTERVAL '30 minutes'),

  -- ── P20: Quần áo Khanh L. ──
  -- C44: Linh N.
  ('00000000-0000-0000-0005-000000000044',
   '00000000-0000-0000-0003-000000000020',
   '00000000-0000-0000-0000-000000000015',
   NULL, 4, 'KL2001', 'completed',
   NOW() - INTERVAL '20 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '20 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '20 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '20 days' - INTERVAL '30 minutes'),

  -- ── P21: Đồ dùng Huyen P. ──
  -- C45: Thuy N.
  ('00000000-0000-0000-0005-000000000045',
   '00000000-0000-0000-0003-000000000021',
   '00000000-0000-0000-0000-000000000012',
   NULL, 3, 'HP2101', 'completed',
   NOW() - INTERVAL '18 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '18 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '18 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '18 days' - INTERVAL '30 minutes'),

  -- ── P22: Sách Khanh V. ──
  -- C46: Linh P.
  ('00000000-0000-0000-0005-000000000046',
   '00000000-0000-0000-0003-000000000022',
   '00000000-0000-0000-0000-000000000008',
   NULL, 1, 'KV2201', 'completed',
   NOW() - INTERVAL '25 days' - INTERVAL '1 hour',
   NOW() - INTERVAL '25 days' - INTERVAL '30 minutes', NULL,
   NOW() - INTERVAL '25 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '25 days' - INTERVAL '30 minutes'),

  -- C47: Phong V.
  ('00000000-0000-0000-0005-000000000047',
   '00000000-0000-0000-0003-000000000022',
   '00000000-0000-0000-0000-000000000013',
   NULL, 1, 'KV2202', 'completed',
   NOW() - INTERVAL '25 days' - INTERVAL '1 hour 10 minutes',
   NOW() - INTERVAL '25 days' - INTERVAL '40 minutes', NULL,
   NOW() - INTERVAL '25 days' - INTERVAL '2 hours',
   NOW() - INTERVAL '25 days' - INTERVAL '40 minutes'),

  -- ── P23: Áo Lacoste cũ (Duc N. as receiver — for rating in 2_2_9) ──
  -- C48: Duc N. — completed yesterday
  ('00000000-0000-0000-0005-000000000048',
   '00000000-0000-0000-0003-000000000023',
   '00000000-0000-0000-0000-000000000014',
   NULL, 1, 'LC2301', 'completed',
   NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NULL,
   NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day');

-- ── 9. MESSAGES ───────────────────────────────────────────────────────────────
-- Key conversations matching prototype text (screens 2_1_3a, 2_1_3b)
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES

  -- ── Claim C08: Nam T. ↔ Bento Cooky (screen 2_1_3b giver inbox, "I'll be there at 5pm") ──
  ('00000000-0000-0000-0006-000000000001',
   '00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0000-000000000002',
   'I''ll be there at 5pm 🙏',
   false, NOW() - INTERVAL '2 minutes'),

  -- Bento Cooky (Dev User) replies in receiver inbox (screen 2_1_3a active section)
  ('00000000-0000-0000-0006-000000000002',
   '00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0000-000000000001',
   'Yes still here, see you 🙏',
   true, NOW() - INTERVAL '1 minute'),

  -- ── Claim C09: Linh P. ↔ Minh H. personal (Lacoste T-shirts, screen 2_1_3b) ──
  ('00000000-0000-0000-0006-000000000003',
   '00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0000-000000000008',
   'What size are they? Thanks 🙏',
   false, NOW() - INTERVAL '23 hours'),

  ('00000000-0000-0000-0006-000000000004',
   '00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'Size M cả 3 cái nhé. Áo polo, đã giặt sạch rồi.',
   true, NOW() - INTERVAL '22 hours'),

  -- ── Claim C19: Minh H. (receiver) ↔ Bento Cooky (screen 2_1_3a active) ──
  ('00000000-0000-0000-0006-000000000005',
   '00000000-0000-0000-0005-000000000019',
   '00000000-0000-0000-0000-000000000001',
   'Yes still here, see you 🙏',
   true, NOW() - INTERVAL '58 minutes'),

  -- ── Claim C20: An H. ↔ Bento Cooky (Mixed soups, screen 2_1_3b "Can I come at 4?") ──
  ('00000000-0000-0000-0006-000000000006',
   '00000000-0000-0000-0005-000000000020',
   '00000000-0000-0000-0000-000000000011',
   'Can I come at 4? 🙏',
   false, NOW() - INTERVAL '25 minutes'),

  -- ── Claim C32: Phuong V. ↔ Gam Coffee (Iced lattes, screen 2_1_3b "On my way") ──
  ('00000000-0000-0000-0006-000000000007',
   '00000000-0000-0000-0005-000000000032',
   '00000000-0000-0000-0000-000000000010',
   'On my way, 5 mins out',
   false, NOW() - INTERVAL '5 minutes'),

  -- ── Claim C39: Minh H. ↔ Tous Les Jours (baguettes, receiver Done section) ──
  ('00000000-0000-0000-0006-000000000008',
   '00000000-0000-0000-0005-000000000039',
   '00000000-0000-0000-0000-000000000016',
   'Bánh còn 2 ổ, đến trước 20h nhé bạn!',
   true, NOW() - INTERVAL '4 days' - INTERVAL '90 minutes'),

  ('00000000-0000-0000-0006-000000000009',
   '00000000-0000-0000-0005-000000000039',
   '00000000-0000-0000-0000-000000000001',
   'Cảm ơn! Mình đến lúc 19h30 ạ.',
   true, NOW() - INTERVAL '4 days' - INTERVAL '80 minutes'),

  -- ── Claim C42: Minh H. ↔ Linh H. (children's books, receiver Done section) ──
  ('00000000-0000-0000-0006-000000000010',
   '00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0000-000000000001',
   'Chị ơi sách thiếu nhi còn không ạ? Mình có em bé 8 tuổi.',
   true, NOW() - INTERVAL '7 days' - INTERVAL '90 minutes'),

  ('00000000-0000-0000-0006-000000000011',
   '00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0000-000000000003',
   'Còn đủ 5 cuốn! Sáng mai bạn ghé lấy được không, 9h–12h.',
   true, NOW() - INTERVAL '7 days' - INTERVAL '80 minutes'),

  -- ── Claim C03: Phuong L. ↔ Minh H. (sách kinh doanh) ──
  ('00000000-0000-0000-0006-000000000012',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000004',
   'Anh ơi bộ sách kinh doanh có cuốn nào về marketing không ạ?',
   true, NOW() - INTERVAL '10 days'),

  ('00000000-0000-0000-0006-000000000013',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000001',
   'Có 2 cuốn marketing và 1 cuốn về brand. Đến lấy cuối tuần nhé!',
   true, NOW() - INTERVAL '10 days' + INTERVAL '30 minutes');

-- ── 10. RATINGS ───────────────────────────────────────────────────────────────
-- Screen 2_2_9 (Thanks & Ratings) shows these 3 ratings for Minh H.:
--   Duc N. ★5 on Lacoste (C48/P23)
--   Phuong L. ★5 on Business books (C03/P03)
--   Linh N. ★5 on Baby stroller (C07/P05)
INSERT INTO ratings (id, claim_id, rater_id, rated_id, score, comment, created_at)
VALUES

  -- Duc N. → Minh H. (Lacoste T-shirt, C48) — "Thank you so much — shirt fits perfectly"
  ('00000000-0000-0000-0007-000000000001',
   '00000000-0000-0000-0005-000000000048',
   '00000000-0000-0000-0000-000000000014',
   '00000000-0000-0000-0000-000000000001',
   5, 'Thank you so much — shirt fits perfectly, great condition!',
   NOW() - INTERVAL '1 day'),

  -- Minh H. → Duc N. (C48, mutual rating)
  ('00000000-0000-0000-0007-000000000002',
   '00000000-0000-0000-0005-000000000048',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000014',
   5, 'Bạn đến đúng hẹn và lịch sự. Cảm ơn đã nhận áo!',
   NOW() - INTERVAL '1 day'),

  -- Phuong L. → Minh H. (sách kinh doanh, C03) — "These books are gold for my MBA prep"
  ('00000000-0000-0000-0007-000000000003',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001',
   5, 'These books are gold for my MBA prep — exactly what I needed, thank you!',
   NOW() - INTERVAL '8 days'),

  -- Minh H. → Phuong L. (C03)
  ('00000000-0000-0000-0007-000000000004',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000004',
   5, 'Bạn Phương rất nhiệt tình, đến đúng giờ. Chúc học MBA thành công!',
   NOW() - INTERVAL '8 days'),

  -- Linh N. → Minh H. (xe đẩy, C07) — "Thank you! My daughter loves the stroller"
  ('00000000-0000-0000-0007-000000000005',
   '00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0000-000000000015',
   '00000000-0000-0000-0000-000000000001',
   5, 'Thank you! My daughter loves the stroller — still in great shape.',
   NOW() - INTERVAL '10 days'),

  -- Minh H. → Linh N. (C07)
  ('00000000-0000-0000-0007-000000000006',
   '00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000015',
   5, 'Linh đến đúng hẹn, em bé dễ thương lắm!',
   NOW() - INTERVAL '10 days'),

  -- Minh H. (receiver) → Tous Les Jours (C39) — ★5 (screen 2_1_3a Done section)
  ('00000000-0000-0000-0007-000000000007',
   '00000000-0000-0000-0005-000000000039',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000016',
   5, 'Bánh mì ngon và còn giòn! Cảm ơn Tous Les Jours.',
   NOW() - INTERVAL '4 days'),

  -- Minh H. (receiver) → Linh H. (C42) — ★4 (screen 2_1_3a Done section)
  ('00000000-0000-0000-0007-000000000008',
   '00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   4, 'Sách tốt, em bé thích. Chị Linh nhiệt tình. Cảm ơn chị!',
   NOW() - INTERVAL '7 days'),

  -- Linh H. → Minh H. (C42, mutual)
  ('00000000-0000-0000-0007-000000000009',
   '00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001',
   5, 'Bạn đến đúng giờ. Hy vọng bé thích sách nhé!',
   NOW() - INTERVAL '7 days'),

  -- Nam T. → Minh H. about Bento Beef (C23 — receiver thanks for org)
  ('00000000-0000-0000-0007-000000000010',
   '00000000-0000-0000-0005-000000000023',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   5, 'Brought home for my family — the kids loved it. Cảm ơn Bento Cooky!',
   NOW() - INTERVAL '1 day' - INTERVAL '30 minutes');

-- ── 11. THANKS ────────────────────────────────────────────────────────────────
INSERT INTO thanks (id, claim_id, from_user_id, to_user_id,
                    message, reaction_emoji, created_at)
VALUES

  -- Phuong L. → Minh H. (sách kinh doanh, C03) — shown in screen 2_2_9
  ('00000000-0000-0000-0008-000000000001',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001',
   'Anh ơi, sách rất hữu ích! Em đang chuẩn bị MBA, bộ sách này đúng thứ em cần nhất. Cảm ơn anh rất nhiều!',
   '📚', NOW() - INTERVAL '8 days'),

  -- Linh N. → Minh H. (xe đẩy, C07) — shown in screen 2_2_9
  ('00000000-0000-0000-0008-000000000002',
   '00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0000-000000000015',
   '00000000-0000-0000-0000-000000000001',
   'Cảm ơn anh! Con bé nhà em rất thích chiếc xe đẩy. Anh tốt bụng quá ạ!',
   '🙏', NOW() - INTERVAL '10 days'),

  -- Nam T. → Minh H. (Bento Beef via Bento Cooky, C23) — shown in screen 2_2_9
  ('00000000-0000-0000-0008-000000000003',
   '00000000-0000-0000-0005-000000000023',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Brought home for my family — the kids loved it. Mái Ấm cảm ơn Bento Cooky nhiều lắm!',
   '❤️', NOW() - INTERVAL '1 day' - INTERVAL '25 minutes'),

  -- Duc N. → Minh H. (Lacoste, C48)
  ('00000000-0000-0000-0008-000000000004',
   '00000000-0000-0000-0005-000000000048',
   '00000000-0000-0000-0000-000000000014',
   '00000000-0000-0000-0000-000000000001',
   'Cảm ơn anh! Áo rất đẹp, vừa y chang size M. Trân trọng tấm lòng của anh!',
   '🙏', NOW() - INTERVAL '1 day'),

  -- Minh H. (receiver) → Tous Les Jours (baguettes, C39)
  ('00000000-0000-0000-0008-000000000005',
   '00000000-0000-0000-0005-000000000039',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000016',
   'Bánh mì ngon tuyệt! Cả nhà ăn hết ngay tối đó. Cảm ơn Tous Les Jours!',
   '🥖', NOW() - INTERVAL '4 days'),

  -- Minh H. (receiver) → Linh H. (sách thiếu nhi, C42)
  ('00000000-0000-0000-0008-000000000006',
   '00000000-0000-0000-0005-000000000042',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   'Cháu thích lắm chị ơi! Đặc biệt bộ Conan, đọc một mạch hết luôn. Cảm ơn chị Linh nhiều!',
   '📖', NOW() - INTERVAL '7 days'),

  -- Thao → Minh H. (ghế văn phòng, C06/P04) — 5th thanks, screen 2_2_9 "5 people said thanks"
  ('00000000-0000-0000-0008-000000000007',
   '00000000-0000-0000-0005-000000000006',
   '00000000-0000-0000-0000-000000000009',
   '00000000-0000-0000-0000-000000000001',
   'Ghế vẫn còn rất tốt! Em kê vào góc học tập rồi, ngồi làm việc thoải mái lắm. Cảm ơn anh nhiều!',
   '🪑', NOW() - INTERVAL '18 days');

-- ── 12. NOTIFICATIONS (for Dev User / Minh H.) ───────────────────────────────
INSERT INTO notifications (id, user_id, type, related_entity_id,
                           title, body, is_read, created_at)
VALUES

  -- Active claim confirmed (unread) — receiver inbox badge
  ('00000000-0000-0000-0009-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'claim_confirmed',
   '00000000-0000-0000-0005-000000000019',
   'Yêu cầu của bạn đã được xác nhận',
   'Bento Cooky đã xác nhận bạn nhận 1 phần Bento Cơm Gà. Mã pickup: A4B7C2',
   false, NOW() - INTERVAL '1 hour'),

  -- New message from Nam T. on giver inbox (unread)
  ('00000000-0000-0000-0009-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'new_message',
   '00000000-0000-0000-0005-000000000008',
   'Tin nhắn mới từ Nam T.',
   'I''ll be there at 5pm 🙏',
   false, NOW() - INTERVAL '2 minutes'),

  -- New message from Phuong V. on giver inbox (unread)
  ('00000000-0000-0000-0009-000000000003',
   '00000000-0000-0000-0000-000000000001',
   'new_message',
   '00000000-0000-0000-0005-000000000032',
   'Tin nhắn mới từ Phương V.',
   'On my way, 5 mins out',
   false, NOW() - INTERVAL '5 minutes'),

  -- Rating received from Duc N. (unread)
  ('00000000-0000-0000-0009-000000000004',
   '00000000-0000-0000-0000-000000000001',
   'rating_received',
   '00000000-0000-0000-0007-000000000001',
   'Bạn nhận được đánh giá mới',
   'Đức N. đánh giá bạn 5 sao: "Thank you so much — shirt fits perfectly, great condition!"',
   false, NOW() - INTERVAL '1 day'),

  -- Rating received from Phuong L. (read)
  ('00000000-0000-0000-0009-000000000005',
   '00000000-0000-0000-0000-000000000001',
   'rating_received',
   '00000000-0000-0000-0007-000000000003',
   'Bạn nhận được đánh giá mới',
   'Phương L. đánh giá bạn 5 sao: "These books are gold for my MBA prep!"',
   true, NOW() - INTERVAL '8 days'),

  -- New claim on Lacoste from Linh P. (read)
  ('00000000-0000-0000-0009-000000000006',
   '00000000-0000-0000-0000-000000000001',
   'claim_created',
   '00000000-0000-0000-0005-000000000001',
   'Có người muốn nhận áo Lacoste',
   'Linh P. muốn nhận 1 chiếc áo polo Lacoste của bạn.',
   true, NOW() - INTERVAL '1 day'),

  -- New claim on Bento Cooky from Nam T. (unread)
  ('00000000-0000-0000-0009-000000000007',
   '00000000-0000-0000-0000-000000000001',
   'claim_created',
   '00000000-0000-0000-0005-000000000008',
   'Bento Cooky có claim mới',
   'Nam T. muốn nhận 1 phần Bento Cơm Gà.',
   false, NOW() - INTERVAL '3 minutes');

-- ── 13a. ADDITIONAL POSTS (screens 2_1_3a, 2_1_4a) ──────────────────────────
-- P24: Gam Coffee iced latte (completed 3 days ago)
--      Needed so Dev User has a "Done: 1 Iced Latte · Gam Coffee" in receiver inbox 2_1_3a
-- P25: Minh H. personal wood bookshelf (completed ~25 days ago)
--      Needed so 2_1_4a shows "2 active · 5 closed" (was only 4 closed)
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES
  ('00000000-0000-0000-0003-000000000024',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Iced latte (8 ly)',
   '8 ly iced latte Gam Coffee còn dư buổi chiều hôm đó. Uống ngon nhất trong 2 giờ.',
   'food', 8, 0, 1,
   NOW()-INTERVAL '3 days'+TIME '14:00',
   NOW()-INTERVAL '3 days'+TIME '17:00',
   NOW()-INTERVAL '3 days'+TIME '17:00',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '3 days'-INTERVAL '1 hour', NOW()-INTERVAL '3 days'),

  ('00000000-0000-0000-0003-000000000025',
   '00000000-0000-0000-0000-000000000001', NULL,
   'Kệ sách gỗ 5 tầng',
   'Kệ sách gỗ tần bì 5 tầng, cao 180cm, đã dùng 4 năm còn tốt. Dọn nhà cho đi. Người nhận tự vận chuyển.',
   'furniture', 1, 0, NULL,
   NOW()-INTERVAL '25 days'+TIME '08:00',
   NOW()-INTERVAL '25 days'+TIME '12:00',
   NOW()-INTERVAL '23 days',
   10.7320, 106.7600,
   '12 Đường Số 7, Phường Cát Lái, Quận 2, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '27 days', NOW()-INTERVAL '23 days');

-- ── 13b. ADDITIONAL CLAIMS ────────────────────────────────────────────────────
-- C51: Minh H. (Dev User as receiver) — picked_up iced latte from Gam Coffee (P24)
--      Shows in receiver inbox 2_1_3a "Done: 1 Iced Latte · PICKED UP · rated ★5"
-- C52: Nam T. — cancelled bookshelf claim on P25 (no pickup, so P25 doesn't affect leaderboard)
INSERT INTO claims (id, post_id, user_id, organization_id, quantity,
                    pickup_code, status,
                    confirmed_at, picked_up_at, cancelled_at,
                    created_at, updated_at)
VALUES
  ('00000000-0000-0000-0005-000000000051',
   '00000000-0000-0000-0003-000000000024',
   '00000000-0000-0000-0000-000000000001',
   NULL, 1, 'GA2451', 'picked_up',
   NOW()-INTERVAL '3 days'-INTERVAL '1 hour',
   NOW()-INTERVAL '3 days'-INTERVAL '30 minutes', NULL,
   NOW()-INTERVAL '3 days'-INTERVAL '90 minutes',
   NOW()-INTERVAL '3 days'-INTERVAL '30 minutes'),

  ('00000000-0000-0000-0005-000000000052',
   '00000000-0000-0000-0003-000000000025',
   '00000000-0000-0000-0000-000000000002',
   NULL, 1, NULL, 'cancelled',
   NULL, NULL, NOW()-INTERVAL '24 days',
   NOW()-INTERVAL '25 days'-INTERVAL '2 hours',
   NOW()-INTERVAL '24 days');

-- ── 13c. ADDITIONAL MESSAGES ──────────────────────────────────────────────────
-- M14: Minh H. (receiver) in C51 — "Got it, thank you so much 🙏"
--      Preview shown in receiver inbox Done section (2_1_3a)
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES
  ('00000000-0000-0000-0006-000000000014',
   '00000000-0000-0000-0005-000000000051',
   '00000000-0000-0000-0000-000000000001',
   'Got it, thank you so much 🙏',
   true, NOW()-INTERVAL '3 days'-INTERVAL '30 minutes');

-- ── 13d. ADDITIONAL RATINGS ───────────────────────────────────────────────────
-- Bento Cooky rating batch: 9 receivers rate Minh H. ★5 for P06 picked_up claims
-- Increases Bento Cooky's visible rating count closer to prototype "★ 4.9 · 28 rates"
-- Minh H. (receiver) rates Gam Coffee ★5 for C51 iced latte
INSERT INTO ratings (id, claim_id, rater_id, rated_id, score, comment, created_at)
VALUES
  ('00000000-0000-0000-0007-000000000011',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000011',
   '00000000-0000-0000-0000-000000000001',
   5, 'Bento ngon tuyệt! Cảm ơn Bento Cooky nhiều ạ.',
   NOW()-INTERVAL '48 minutes'),

  ('00000000-0000-0000-0007-000000000012',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000013',
   '00000000-0000-0000-0000-000000000001',
   5, 'Cơm gà ngon lắm, đúng bữa trưa đói.',
   NOW()-INTERVAL '1 hour'),

  ('00000000-0000-0000-0007-000000000013',
   '00000000-0000-0000-0005-000000000016',
   '00000000-0000-0000-0000-000000000005',
   '00000000-0000-0000-0000-000000000001',
   5, 'Hộp cơm sạch sẽ, đầy đủ. Cảm ơn!',
   NOW()-INTERVAL '65 minutes'),

  ('00000000-0000-0000-0007-000000000014',
   '00000000-0000-0000-0005-000000000017',
   '00000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001',
   5, 'Đồ ăn ngon, dịch vụ tốt.',
   NOW()-INTERVAL '75 minutes'),

  ('00000000-0000-0000-0007-000000000015',
   '00000000-0000-0000-0005-000000000018',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001',
   4, 'Ngon. Hơi bận nhưng được.',
   NOW()-INTERVAL '85 minutes'),

  ('00000000-0000-0000-0007-000000000016',
   '00000000-0000-0000-0005-000000000049',
   '00000000-0000-0000-0000-000000000014',
   '00000000-0000-0000-0000-000000000001',
   5, 'Quá tuyệt! Bento Cooky 10 điểm.',
   NOW()-INTERVAL '85 minutes'),

  ('00000000-0000-0000-0007-000000000017',
   '00000000-0000-0000-0005-000000000050',
   '00000000-0000-0000-0000-000000000015',
   '00000000-0000-0000-0000-000000000001',
   5, 'Rất ngon, cảm ơn!',
   NOW()-INTERVAL '95 minutes'),

  ('00000000-0000-0000-0007-000000000018',
   '00000000-0000-0000-0005-000000000024',
   '00000000-0000-0000-0000-000000000012',
   '00000000-0000-0000-0000-000000000001',
   5, 'Bento bò mềm ngon! Đại diện cả nhóm cảm ơn.',
   NOW()-INTERVAL '1 day'-INTERVAL '30 minutes'),

  ('00000000-0000-0000-0007-000000000019',
   '00000000-0000-0000-0005-000000000025',
   '00000000-0000-0000-0000-000000000013',
   '00000000-0000-0000-0000-000000000001',
   5, 'Ngon lắm. Cảm ơn!',
   NOW()-INTERVAL '1 day'-INTERVAL '2 hours'),

  -- Minh H. (receiver) → Minh H. (giver = owner of Gam Coffee) for C51 iced latte
  ('00000000-0000-0000-0007-000000000020',
   '00000000-0000-0000-0005-000000000051',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000001',
   5, 'Latte ngon và mát! Cảm ơn Gam Coffee.',
   NOW()-INTERVAL '3 days'-INTERVAL '20 minutes');

-- ── 13f. NAM T. CLAIM HISTORY (for "1 active · 8 completed" in profile 2_1_4c) ─────
-- Nam T. completed claims: C23(P08)+C36(P13)+C43(P19)+C53(P26)+C54(P27)+C55(P28)+C56(P29)+C57(P30)=8
-- C52 is cancelled so P25 does not add to Minh H. personal leaderboard (stays at 7)
-- New posts are Bento Cooky / Gam Coffee business posts → business leaderboard only
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES
  -- P26: Bento Cooky (5 weeks ago)
  ('00000000-0000-0000-0003-000000000026',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Bento cơm sườn (6 phần)',
   '6 hộp bento cơm sườn nướng còn dư cuối ngày.',
   'food', 6, 0, NULL,
   NOW()-INTERVAL '5 weeks'+TIME '11:00',
   NOW()-INTERVAL '5 weeks'+TIME '14:00',
   NOW()-INTERVAL '5 weeks'+TIME '14:00',
   10.7754, 106.7022,
   '248 Lê Lai, Phường Bến Thành, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '5 weeks'-INTERVAL '2 hours', NOW()-INTERVAL '5 weeks'),

  -- P27: Bento Cooky (7 weeks ago)
  ('00000000-0000-0000-0003-000000000027',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Xôi gà (8 phần)',
   '8 phần xôi gà xé cuối buổi sáng, tặng trước 11h30.',
   'food', 8, 0, NULL,
   NOW()-INTERVAL '7 weeks'+TIME '10:30',
   NOW()-INTERVAL '7 weeks'+TIME '11:30',
   NOW()-INTERVAL '7 weeks'+TIME '11:30',
   10.7754, 106.7022,
   '248 Lê Lai, Phường Bến Thành, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '7 weeks'-INTERVAL '2 hours', NOW()-INTERVAL '7 weeks'),

  -- P28: Gam Coffee (6 weeks ago)
  ('00000000-0000-0000-0003-000000000028',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Cà phê filter (10 ly)',
   '10 ly cà phê filter sáng sớm còn dư, uống ngon nhất trong 1 giờ.',
   'food', 10, 0, NULL,
   NOW()-INTERVAL '6 weeks'+TIME '07:30',
   NOW()-INTERVAL '6 weeks'+TIME '09:00',
   NOW()-INTERVAL '6 weeks'+TIME '09:00',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '6 weeks'-INTERVAL '2 hours', NOW()-INTERVAL '6 weeks'),

  -- P29: Gam Coffee (8 weeks ago)
  ('00000000-0000-0000-0003-000000000029',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000002',
   'Matcha latte (5 ly)',
   '5 ly matcha latte pha sáng còn dư hôm nay.',
   'food', 5, 0, NULL,
   NOW()-INTERVAL '8 weeks'+TIME '09:00',
   NOW()-INTERVAL '8 weeks'+TIME '11:00',
   NOW()-INTERVAL '8 weeks'+TIME '11:00',
   10.7769, 106.7039,
   '15 Nguyễn Huệ, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '8 weeks'-INTERVAL '2 hours', NOW()-INTERVAL '8 weeks'),

  -- P30: Bento Cooky (10 weeks ago)
  ('00000000-0000-0000-0003-000000000030',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0001-000000000001',
   'Cơm thịt kho (4 phần)',
   '4 phần cơm thịt kho tàu cuối ca trưa.',
   'food', 4, 0, NULL,
   NOW()-INTERVAL '10 weeks'+TIME '13:00',
   NOW()-INTERVAL '10 weeks'+TIME '15:00',
   NOW()-INTERVAL '10 weeks'+TIME '15:00',
   10.7754, 106.7022,
   '248 Lê Lai, Phường Bến Thành, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW()-INTERVAL '10 weeks'-INTERVAL '2 hours', NOW()-INTERVAL '10 weeks');

INSERT INTO claims (id, post_id, user_id, organization_id, quantity,
                    pickup_code, status,
                    confirmed_at, picked_up_at, cancelled_at,
                    created_at, updated_at)
VALUES
  -- C53: Nam T. via Mái Ấm on P26 (Bento sườn, 5 weeks ago)
  ('00000000-0000-0000-0005-000000000053',
   '00000000-0000-0000-0003-000000000026',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   1, 'BT2601', 'completed',
   NOW()-INTERVAL '5 weeks'-INTERVAL '2 hours',
   NOW()-INTERVAL '5 weeks'-INTERVAL '1 hour', NULL,
   NOW()-INTERVAL '5 weeks'-INTERVAL '3 hours',
   NOW()-INTERVAL '5 weeks'-INTERVAL '1 hour'),

  -- C54: Nam T. via Mái Ấm on P27 (Xôi gà, 7 weeks ago)
  ('00000000-0000-0000-0005-000000000054',
   '00000000-0000-0000-0003-000000000027',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   1, 'BT2701', 'completed',
   NOW()-INTERVAL '7 weeks'-INTERVAL '2 hours',
   NOW()-INTERVAL '7 weeks'-INTERVAL '1 hour', NULL,
   NOW()-INTERVAL '7 weeks'-INTERVAL '3 hours',
   NOW()-INTERVAL '7 weeks'-INTERVAL '1 hour'),

  -- C55: Nam T. via Mái Ấm on P28 (Gam Coffee filter, 6 weeks ago)
  ('00000000-0000-0000-0005-000000000055',
   '00000000-0000-0000-0003-000000000028',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   1, 'GA2801', 'completed',
   NOW()-INTERVAL '6 weeks'-INTERVAL '2 hours',
   NOW()-INTERVAL '6 weeks'-INTERVAL '1 hour', NULL,
   NOW()-INTERVAL '6 weeks'-INTERVAL '3 hours',
   NOW()-INTERVAL '6 weeks'-INTERVAL '1 hour'),

  -- C56: Nam T. via Mái Ấm on P29 (Gam Coffee matcha, 8 weeks ago)
  ('00000000-0000-0000-0005-000000000056',
   '00000000-0000-0000-0003-000000000029',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0002-000000000001',
   1, 'GA2901', 'completed',
   NOW()-INTERVAL '8 weeks'-INTERVAL '2 hours',
   NOW()-INTERVAL '8 weeks'-INTERVAL '1 hour', NULL,
   NOW()-INTERVAL '8 weeks'-INTERVAL '3 hours',
   NOW()-INTERVAL '8 weeks'-INTERVAL '1 hour'),

  -- C57: Nam T. personal on P30 (Bento cơm thịt kho, 10 weeks ago)
  ('00000000-0000-0000-0005-000000000057',
   '00000000-0000-0000-0003-000000000030',
   '00000000-0000-0000-0000-000000000002',
   NULL, 1, 'BT3001', 'completed',
   NOW()-INTERVAL '10 weeks'-INTERVAL '2 hours',
   NOW()-INTERVAL '10 weeks'-INTERVAL '1 hour', NULL,
   NOW()-INTERVAL '10 weeks'-INTERVAL '3 hours',
   NOW()-INTERVAL '10 weeks'-INTERVAL '1 hour');

-- ── 13e. ADDITIONAL THANKS ────────────────────────────────────────────────────
-- Brings thanks_received for Minh H. from 5 → 9 (to match "9 notes" in 2_1_4a profile)
INSERT INTO thanks (id, claim_id, from_user_id, to_user_id,
                    message, reaction_emoji, created_at)
VALUES
  -- T08: Phong V. → Minh H. (C12/P06 Bento, picked_up)
  ('00000000-0000-0000-0008-000000000008',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000013',
   '00000000-0000-0000-0000-000000000001',
   'Cơm gà ngon lắm! Cảm ơn Bento Cooky đã tặng bữa trưa. Hôm nào ghé quán ủng hộ thêm nhé!',
   '🍱', NOW()-INTERVAL '1 hour'),

  -- T09: An H. → Minh H. (C11/P06 Bento, picked_up)
  ('00000000-0000-0000-0008-000000000009',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000011',
   '00000000-0000-0000-0000-000000000001',
   'Bento ngon tuyệt! Cảm ơn anh/chị nhiều ạ. Rất vui được nhận.',
   '🙏', NOW()-INTERVAL '48 minutes'),

  -- T10: Linh H. → Minh H. (C17/P06 Bento, picked_up)
  ('00000000-0000-0000-0008-000000000010',
   '00000000-0000-0000-0005-000000000017',
   '00000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001',
   'Cảm ơn Bento Cooky! Hộp cơm đẹp và ngon. Sẽ nhắc bạn bè ủng hộ.',
   '❤️', NOW()-INTERVAL '75 minutes'),

  -- T11: Khanh L. → Minh H. (C16/P06 Bento, picked_up)
  ('00000000-0000-0000-0008-000000000011',
   '00000000-0000-0000-0005-000000000016',
   '00000000-0000-0000-0000-000000000005',
   '00000000-0000-0000-0000-000000000001',
   'Ngon quá! Bento đúng bữa trưa đói bụng. Cảm ơn anh nhiều!',
   '👍', NOW()-INTERVAL '65 minutes'),

  -- T12: Nam T. → Minh H. (C36/P13 Gam Coffee cà phê sáng)
  -- Nam T. "6 notes to givers" count: T03(C23)+T12(C36)+T13(C43)+T14(C53)+T15(C55)+T16(C57)=6
  ('00000000-0000-0000-0008-000000000012',
   '00000000-0000-0000-0005-000000000036',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Cà phê sáng ngon tuyệt! Cả nhà được buổi sáng thật ý nghĩa. Cảm ơn Gam Coffee nhiều!',
   '☕', NOW()-INTERVAL '1 day'-INTERVAL '4 hours'),

  -- T13: Nam T. → Phuong L. (C43/P19 Đồ gia dụng)
  ('00000000-0000-0000-0008-000000000013',
   '00000000-0000-0000-0005-000000000043',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000004',
   'Đồ dùng rất tiện và còn tốt. Mái Ấm chúng mình dùng hàng ngày luôn. Cảm ơn chị Phương!',
   '🏡', NOW()-INTERVAL '14 days'),

  -- T14: Nam T. → Minh H. (C53/P26 Bento sườn)
  ('00000000-0000-0000-0008-000000000014',
   '00000000-0000-0000-0005-000000000053',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Bento sườn nướng ngon hơn mình tưởng! Các bé ở Mái Ấm thích lắm. Cảm ơn Bento Cooky!',
   '🍱', NOW()-INTERVAL '5 weeks'),

  -- T15: Nam T. → Minh H. (C55/P28 Gam Coffee filter)
  ('00000000-0000-0000-0008-000000000015',
   '00000000-0000-0000-0005-000000000055',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Cà phê filter thơm ngon, buổi sáng tuyệt vời cho anh chị em Mái Ấm. Cảm ơn Gam Coffee!',
   '☕', NOW()-INTERVAL '6 weeks'),

  -- T16: Nam T. → Minh H. (C57/P30 Bento cơm thịt kho)
  ('00000000-0000-0000-0008-000000000016',
   '00000000-0000-0000-0005-000000000057',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Cơm thịt kho tàu đậm đà, đúng vị miền Nam. Trẻ em nhà Mái Ấm đều thích. Cảm ơn Bento Cooky!',
   '❤️', NOW()-INTERVAL '10 weeks');

-- ── 13g. HOME FEED ACTIVE POSTS (P31–P34) ────────────────────────────────────
-- 4 thêm active posts để khớp 8 cards trong prototype 2_1_1 home feed:
-- P31: Tous Les Jours "Baguettes & pastries (8)" qty 5/5 · closes in 5 days
-- P32: Đức Nguyễn "Men's shirts, size L" qty 1/3 · closes in 3 days
-- P33: Huyền Phạm "Wooden dining chair" qty 1/1 · closes in 12 days
-- P34: Khánh Vũ "Business books (stack of 8)" qty 8/8 · closes in 6 days
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES
  -- P31. Tous Les Jours bánh mì & bánh ngọt (active)
  ('00000000-0000-0000-0003-000000000031',
   '00000000-0000-0000-0000-000000000016',
   '00000000-0000-0000-0001-000000000003',
   'Bánh mì Pháp & bánh ngọt',
   '5 bánh mì Pháp và bánh ngọt cuối ngày còn tươi. Tặng trước khi đóng cửa.',
   'food', 5, 5, 1,
   NOW()::date + TIME '16:00',
   NOW()::date + TIME '20:00',
   NOW() + INTERVAL '5 days',
   10.7773, 106.7030,
   '55 Lê Thánh Tôn, Phường Bến Nghé, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Tous Les Jours tặng bánh mì Pháp và bánh ngọt cuối ngày tại Q.1.',
   NOW() - INTERVAL '4 hours', NOW()),

  -- P32. Đức Nguyễn áo sơ mi (active) — prototype "Men's shirts, size L (4)" qty 1/3
  ('00000000-0000-0000-0003-000000000032',
   '00000000-0000-0000-0000-000000000014',
   NULL,
   'Áo sơ mi nam size L (4 cái)',
   '3 áo sơ mi công sở nam size L còn mới. Chỉ còn 1 áo chưa được nhận.',
   'clothes', 3, 1, 1,
   NOW()::date + TIME '17:00',
   NOW()::date + TIME '20:00',
   NOW() + INTERVAL '3 days',
   10.7730, 106.6975,
   '23 Lý Tự Trọng, Phường Sài Gòn, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false, NULL,
   NOW() - INTERVAL '2 days', NOW()),

  -- P33. Huyền Phạm ghế ăn gỗ (active) — prototype "Wooden dining chair" qty 1/1
  ('00000000-0000-0000-0003-000000000033',
   '00000000-0000-0000-0000-000000000006',
   NULL,
   'Ghế ăn gỗ',
   'Ghế ăn gỗ tròn, còn chắc, chân chưa bị lung lay. Tặng cho gia đình nào cần.',
   'furniture', 1, 1, 1,
   NULL, NULL,
   NOW() + INTERVAL '12 days',
   10.7960, 106.7200,
   '8 Nguyễn Xí, Phường 26, Quận Bình Thạnh, TP.HCM',
   'Hồ Chí Minh',
   'active', false, NULL,
   NOW() - INTERVAL '3 hours', NOW()),

  -- P34. Khánh Vũ sách kinh doanh (active) — prototype "Business books (stack of 8)" qty 8/8
  ('00000000-0000-0000-0003-000000000034',
   '00000000-0000-0000-0000-000000000007',
   NULL,
   'Sách kinh doanh (8 quyển)',
   '8 quyển sách về kinh doanh, quản trị, marketing. Tặng cho bạn đang học hoặc khởi nghiệp.',
   'books', 8, 8, NULL,
   NULL, NULL,
   NOW() + INTERVAL '6 days',
   10.7700, 106.7010,
   '15 Bến Chương Dương, Phường Cầu Ông Lãnh, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false, NULL,
   NOW() - INTERVAL '5 hours', NOW());

-- ── 7. POST IMAGES ────────────────────────────────────────────────────────────
INSERT INTO post_images (id, post_id, url, position) VALUES
  -- P01 Lacoste shirts (screen 2_4_1 hero, 2_1_1 item 1)
  ('00000000-0000-0000-0004-000000000001','00000000-0000-0000-0003-000000000001','https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&q=80&auto=format&fit=crop',0),
  ('00000000-0000-0000-0004-000000000002','00000000-0000-0000-0003-000000000001','https://images.unsplash.com/photo-1598522325074-042db73aa4e5?w=800&q=80&auto=format&fit=crop',1),
  -- P02 Kemei haircut machine (2_1_1 item 2)
  ('00000000-0000-0000-0004-000000000003','00000000-0000-0000-0003-000000000002','https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=800&q=80&auto=format&fit=crop',0),
  -- P03 Sách kinh doanh (completed, 2_1_1 item 8 equivalent)
  ('00000000-0000-0000-0004-000000000004','00000000-0000-0000-0003-000000000003','https://images.unsplash.com/photo-1524578271613-d550eacf6090?w=800&q=80&auto=format&fit=crop',0),
  -- P06 20 Hộp Cơm Gà — Bento Cooky (2_1_1 item 3, 2_1_3 message thread)
  ('00000000-0000-0000-0004-000000000005','00000000-0000-0000-0003-000000000006','https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=800&q=80&auto=format&fit=crop',0),
  ('00000000-0000-0000-0004-000000000006','00000000-0000-0000-0003-000000000006','https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80&auto=format&fit=crop',1),
  -- P07 Canh chua cá hú thập cẩm (message thread soup)
  ('00000000-0000-0000-0004-000000000007','00000000-0000-0000-0003-000000000007','https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=800&q=80&auto=format&fit=crop',0),
  -- P12 Iced lattes — Gam Coffee (2_1_1 item 4, 2_1_3 message thread)
  ('00000000-0000-0000-0004-000000000008','00000000-0000-0000-0003-000000000012','https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=800&q=80&auto=format&fit=crop',0),
  -- P15 Baguettes & pastries — Tous Les Jours (2_1_1 item 5)
  ('00000000-0000-0000-0004-000000000009','00000000-0000-0000-0003-000000000015','https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80&auto=format&fit=crop',0),
  -- P17 Pizza — Pizza 4P's
  ('00000000-0000-0000-0004-000000000010','00000000-0000-0000-0003-000000000017','https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80&auto=format&fit=crop',0),
  -- P18 Sách thiếu nhi — Linh H.
  ('00000000-0000-0000-0004-000000000011','00000000-0000-0000-0003-000000000018','https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80&auto=format&fit=crop',0),
  -- P05 Xe đẩy em bé (2_2_9 thanks screen)
  ('00000000-0000-0000-0004-000000000012','00000000-0000-0000-0003-000000000005','https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=800&q=80&auto=format&fit=crop',0),
  -- P24 Iced latte (second Gam Coffee post, 2_1_3 messages)
  ('00000000-0000-0000-0004-000000000013','00000000-0000-0000-0003-000000000024','https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=800&q=80&auto=format&fit=crop',0),
  -- P31 Bánh mì Pháp & bánh ngọt — Tous Les Jours (active home feed, 2_1_1 item 5)
  ('00000000-0000-0000-0004-000000000014','00000000-0000-0000-0003-000000000031','https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80&auto=format&fit=crop',0),
  -- P32 Áo sơ mi nam — Đức Nguyễn (active home feed, 2_1_1 item 6)
  ('00000000-0000-0000-0004-000000000015','00000000-0000-0000-0003-000000000032','https://images.unsplash.com/photo-1598522325074-042db73aa4e5?w=800&q=80&auto=format&fit=crop',0),
  -- P33 Ghế ăn gỗ (active home feed, 2_1_1 item 7)
  ('00000000-0000-0000-0004-000000000016','00000000-0000-0000-0003-000000000033','https://images.unsplash.com/photo-1503602642458-232111445657?w=800&q=80&auto=format&fit=crop',0),
  -- P34 Sách kinh doanh (active home feed, 2_1_1 item 8)
  ('00000000-0000-0000-0004-000000000017','00000000-0000-0000-0003-000000000034','https://images.unsplash.com/photo-1524578271613-d550eacf6090?w=800&q=80&auto=format&fit=crop',0);

-- ── 13. BUSINESS_MEMBERS & ORG_MEMBERS ───────────────────────────────────────
-- Migration 006 backfills from businesses/organizations tables automatically,
-- but we TRUNCATE those tables above so we need to insert manually.
INSERT INTO business_members (business_id, user_id, role, joined_at) VALUES
  ('00000000-0000-0000-0001-000000000001','00000000-0000-0000-0000-000000000001','owner',NOW()-INTERVAL '210 days'),
  ('00000000-0000-0000-0001-000000000002','00000000-0000-0000-0000-000000000001','owner',NOW()-INTERVAL '190 days'),
  ('00000000-0000-0000-0001-000000000003','00000000-0000-0000-0000-000000000016','owner',NOW()-INTERVAL '260 days'),
  ('00000000-0000-0000-0001-000000000004','00000000-0000-0000-0000-000000000017','owner',NOW()-INTERVAL '310 days'),
  ('00000000-0000-0000-0001-000000000005','00000000-0000-0000-0000-000000000001','owner',NOW()-INTERVAL '5 days'),
  ('00000000-0000-0000-0001-000000000006','00000000-0000-0000-0000-000000000001','owner',NOW()-INTERVAL '30 days');

INSERT INTO org_members (org_id, user_id, role, joined_at) VALUES
  ('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0000-000000000002','admin',NOW()-INTERVAL '160 days'),
  ('00000000-0000-0000-0002-000000000002','00000000-0000-0000-0000-000000000002','admin',NOW()-INTERVAL '3 days'),
  ('00000000-0000-0000-0002-000000000003','00000000-0000-0000-0000-000000000002','admin',NOW()-INTERVAL '14 days');

COMMIT;
