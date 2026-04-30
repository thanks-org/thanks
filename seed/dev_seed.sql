-- =============================================================
-- seed/dev_seed.sql — Prototype-quality connected seed data
-- =============================================================
-- Covers all screens in the Thanks app. All foreign keys are
-- internally consistent. Data mirrors the UI prototype.
--
-- Dev user (the "logged-in" test user for local dev):
--   auth_providers: provider=google, provider_user_id='dev-user-001'
--   email: dev@thanks.test / name: Dev User
--   user UUID: 00000000-0000-0000-0000-000000000001
--
-- ⚠️  DESTRUCTIVE: truncates ALL application tables before inserting.
--     Only run on a local dev database. Never on staging/production.
--
-- Run:
--   make seed-fake          (from thanks-backend/)
--   # or directly:
--   psql $DATABASE_URL -f seed/fake_seed.sql
-- =============================================================

BEGIN;

-- ── 0. Wipe all application data ─────────────────────────────────────────
TRUNCATE TABLE
    invites, org_members, business_members,
    notifications, thanks, ratings, messages,
    claims, post_images, post_schedules, posts,
    organizations, businesses,
    auth_providers, sessions, device_tokens,
    revoked_tokens, users
CASCADE;

-- ── 1. USERS ─────────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0000-00000000000X  (X = 1..6)
INSERT INTO users (id, name, email, phone, avatar_url, bio,
                   role_type, giver_type, receiver_type,
                   city, is_verified, rating_avg, rating_count,
                   created_at, updated_at)
VALUES
  -- 1. Dev User — the logged-in test account
  ('00000000-0000-0000-0000-000000000001',
   'Dev User', 'dev@thanks.test', NULL,
   'https://i.pravatar.cc/150?img=1',
   'Tài khoản test cho môi trường dev',
   'both', 'personal', 'personal',
   'Hồ Chí Minh', false, 4.50, 3,
   NOW() - INTERVAL '90 days', NOW()),

  -- 2. Nguyễn Văn Phượng — business giver (Bánh Mì Phượng)
  ('00000000-0000-0000-0000-000000000002',
   'Nguyễn Văn Phượng', 'phuong@banhmi.com', '0901234567',
   'https://i.pravatar.cc/150?img=12',
   'Chủ Bánh Mì Phượng — chia sẻ bánh mì miễn phí mỗi ngày',
   'giver', 'business', NULL,
   'Hồ Chí Minh', true, 4.90, 42,
   NOW() - INTERVAL '180 days', NOW()),

  -- 3. Trần Thị Mai — top personal giver
  ('00000000-0000-0000-0000-000000000003',
   'Trần Thị Mai', 'mai@gmail.com', '0912345678',
   'https://i.pravatar.cc/150?img=5',
   'Thích tặng đồ dùng còn tốt cho người cần',
   'giver', 'personal', NULL,
   'Hồ Chí Minh', true, 4.80, 28,
   NOW() - INTERVAL '120 days', NOW()),

  -- 4. Lê Minh Đức — org admin (Mái Ấm Thiên Tâm)
  ('00000000-0000-0000-0000-000000000004',
   'Lê Minh Đức', 'duc@maiam.org', '0923456789',
   'https://i.pravatar.cc/150?img=33',
   'Quản lý Mái Ấm Thiên Tâm',
   'receiver', NULL, 'organization',
   'Hồ Chí Minh', false, 0.00, 0,
   NOW() - INTERVAL '60 days', NOW()),

  -- 5. Phạm Thị Hoa — personal receiver
  ('00000000-0000-0000-0000-000000000005',
   'Phạm Thị Hoa', 'hoa@gmail.com', '0934567890',
   'https://i.pravatar.cc/150?img=9',
   NULL,
   'receiver', NULL, 'personal',
   'Hồ Chí Minh', false, 5.00, 2,
   NOW() - INTERVAL '45 days', NOW()),

  -- 6. Hoàng Minh Tuấn — personal giver #2, Hà Nội
  ('00000000-0000-0000-0000-000000000006',
   'Hoàng Minh Tuấn', 'tuan@gmail.com', '0945678901',
   'https://i.pravatar.cc/150?img=15',
   'Hay dọn nhà và có nhiều đồ cũ còn dùng tốt',
   'both', 'personal', 'personal',
   'Hà Nội', false, 4.70, 15,
   NOW() - INTERVAL '200 days', NOW());

-- ── 2. BUSINESSES ────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0001-00000000000X
INSERT INTO businesses (id, owner_user_id, name, category,
                        logo_url, phone, description,
                        address, latitude, longitude, city,
                        verification_status, verified_at, is_active,
                        created_at, updated_at)
VALUES
  -- Bánh Mì Phượng (verified — appears on posts and leaderboard)
  ('00000000-0000-0000-0001-000000000001',
   '00000000-0000-0000-0000-000000000002',
   'Bánh Mì Phượng', 'restaurant',
   'https://picsum.photos/seed/biz_banhmi/200/200',
   '0901234567',
   'Tiệm bánh mì gia truyền 20 năm. Mỗi ngày tặng bánh mì miễn phí 11h–12h trưa.',
   '2B Lê Lợi, Phường Bến Nghé, Quận 1, TP.HCM',
   10.7745, 106.7017, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '150 days', true,
   NOW() - INTERVAL '160 days', NOW()),

  -- Cà Phê Nhớ (pending_review — appears in dev user's profile as "chờ xét duyệt")
  ('00000000-0000-0000-0001-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Cà Phê Nhớ', 'cafe',
   'https://picsum.photos/seed/biz_cafe/200/200',
   '0901111111',
   'Quán cà phê nhỏ, thường xuyên tặng cà phê cho người vô gia cư buổi sáng.',
   '45 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP.HCM',
   10.7769, 106.7009, 'Hồ Chí Minh',
   'pending_review', NULL, true,
   NOW() - INTERVAL '3 days', NOW());

-- ── 3. ORGANIZATIONS ─────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0002-00000000000X
INSERT INTO organizations (id, owner_user_id, name, category,
                           logo_url, phone, description, address,
                           contact_person_name, latitude, longitude, city,
                           verification_status, verified_at, is_active,
                           created_at, updated_at)
VALUES
  ('00000000-0000-0000-0002-000000000001',
   '00000000-0000-0000-0000-000000000004',
   'Mái Ấm Thiên Tâm', 'social',
   'https://picsum.photos/seed/org_maiam/200/200',
   '0923456789',
   'Tổ chức phi lợi nhuận hỗ trợ trẻ em khó khăn và người vô gia cư tại TP.HCM.',
   '78 Đinh Tiên Hoàng, Quận 1, TP.HCM',
   'Lê Minh Đức',
   10.7800, 106.6960, 'Hồ Chí Minh',
   'verified', NOW() - INTERVAL '40 days', true,
   NOW() - INTERVAL '50 days', NOW());

-- ── 4. AUTH PROVIDERS ────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0010-00000000000X
-- Dev login: backend accepts base64({"sub":"<provider_user_id>","email":"..."})
-- as id_token when JWT_SECRET == dev-only-secret-change-me (default dev mode)
INSERT INTO auth_providers (id, user_id, provider, provider_user_id, email, created_at)
VALUES
  -- 1. Dev User — "both" role, has active claim + history
  ('00000000-0000-0000-0010-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'google', 'dev-user-001', 'dev@thanks.test',
   NOW() - INTERVAL '90 days'),

  -- 2. Phượng — giver, business: Bánh Mì Phượng
  ('00000000-0000-0000-0010-000000000002',
   '00000000-0000-0000-0000-000000000002',
   'google', 'seed-phuong-002', 'phuong@banhmi.com',
   NOW() - INTERVAL '180 days'),

  -- 3. Mai — giver, personal, top leaderboard
  ('00000000-0000-0000-0010-000000000003',
   '00000000-0000-0000-0000-000000000003',
   'google', 'seed-mai-003', 'mai@gmail.com',
   NOW() - INTERVAL '120 days'),

  -- 4. Đức — receiver, org: Mái Ấm Thiên Tâm
  ('00000000-0000-0000-0010-000000000004',
   '00000000-0000-0000-0000-000000000004',
   'google', 'seed-duc-004', 'duc@maiam.org',
   NOW() - INTERVAL '60 days'),

  -- 5. Hoa — receiver, personal
  ('00000000-0000-0000-0010-000000000005',
   '00000000-0000-0000-0000-000000000005',
   'google', 'seed-hoa-005', 'hoa@gmail.com',
   NOW() - INTERVAL '45 days'),

  -- 6. Tuấn — giver, personal, Hà Nội
  ('00000000-0000-0000-0010-000000000006',
   '00000000-0000-0000-0000-000000000006',
   'google', 'seed-tuan-006', 'tuan@gmail.com',
   NOW() - INTERVAL '200 days');

-- ── 5. POSTS ─────────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0003-00000000000X
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES
  -- 1. Bánh mì thịt nướng — active, recurring, business post (screen: Home Feed, Item Detail, Who Claimed)
  ('00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0001-000000000001',
   'Bánh mì thịt nướng miễn phí',
   'Mỗi ngày 11h–12h trưa, tiệm tặng 50 ổ bánh mì thịt nướng cho người cần. Ai đến trước được trước. Xuất trình mã pickup để nhận.',
   'food',
   50, 43, 5,
   NOW() + INTERVAL '8 hours',
   NOW() + INTERVAL '9 hours',
   NOW() + INTERVAL '14 days',
   10.7745, 106.7017,
   '2B Lê Lợi, Phường Bến Nghé, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', true,
   'Tiệm bánh mì tặng 50 ổ thịt nướng mỗi ngày 11h–12h tại Quận 1.',
   NOW() - INTERVAL '10 days', NOW()),

  -- 2. Quần áo trẻ em — active, personal giver (screen: Home Feed, Item Detail)
  ('00000000-0000-0000-0003-000000000002',
   '00000000-0000-0000-0000-000000000003',
   NULL,
   'Quần áo trẻ em size 2–5 tuổi',
   'Có 5 bộ quần áo mùa hè còn rất mới, size 2–5 tuổi, đã giặt sạch và là phẳng. Ưu tiên gia đình khó khăn. Nhận tại nhà, nhắn tin trước.',
   'clothes',
   5, 3, NULL,
   NOW() + INTERVAL '1 day',
   NOW() + INTERVAL '1 day' + INTERVAL '4 hours',
   NOW() + INTERVAL '7 days',
   10.7800, 106.7050,
   'Quận 3, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Tặng 5 bộ quần áo trẻ em size 2–5 tuổi, còn mới, tại Quận 3.',
   NOW() - INTERVAL '3 days', NOW()),

  -- 3. Sách giáo khoa lớp 12 — active, dev user as giver (screen: Home Feed, Who Claimed from giver POV)
  ('00000000-0000-0000-0003-000000000003',
   '00000000-0000-0000-0000-000000000001',
   NULL,
   'Sách giáo khoa lớp 12 đầy đủ bộ',
   'Bộ sách giáo khoa lớp 12 đầy đủ tất cả môn, còn mới 80%. Tặng cho học sinh cần. Lấy vào cuối tuần tại Quận 1.',
   'books',
   10, 7, NULL,
   NOW() + INTERVAL '5 days',
   NOW() + INTERVAL '5 days' + INTERVAL '4 hours',
   NOW() + INTERVAL '21 days',
   10.7769, 106.7009,
   'Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'active', false,
   'Tặng bộ sách giáo khoa lớp 12 đầy đủ, còn mới 80%, tại Quận 1.',
   NOW() - INTERVAL '5 days', NOW()),

  -- 4. Tủ lạnh Panasonic — active, Hà Nội, all claimed (screen: Home Feed, Item Detail)
  ('00000000-0000-0000-0003-000000000004',
   '00000000-0000-0000-0000-000000000006',
   NULL,
   'Tủ lạnh Panasonic 150L còn dùng tốt',
   'Dọn nhà nên cho tủ lạnh Panasonic 150L, đời 2019, còn lạnh tốt. Người nhận tự vận chuyển. Đang ở Cầu Giấy, Hà Nội.',
   'furniture',
   1, 0, NULL,
   NOW() + INTERVAL '2 days',
   NOW() + INTERVAL '2 days' + INTERVAL '6 hours',
   NOW() + INTERVAL '10 days',
   21.0285, 105.8542,
   'Cầu Giấy, Hà Nội',
   'Hà Nội',
   'active', false,
   'Tặng tủ lạnh Panasonic 150L đời 2019 tại Hà Nội, người nhận tự vận chuyển.',
   NOW() - INTERVAL '4 days', NOW()),

  -- 5. Điện thoại Samsung A52 — active, Hà Nội, 1 còn lại (screen: Home Feed, Item Detail)
  ('00000000-0000-0000-0003-000000000005',
   '00000000-0000-0000-0000-000000000006',
   NULL,
   'Điện thoại Samsung A52 đã qua sử dụng',
   'Điện thoại Samsung A52, dùng 1 năm, màn hình nguyên vẹn, pin còn 85%. Có 2 cái, ưu tiên người thực sự cần. Tại Cầu Giấy, Hà Nội.',
   'tech',
   2, 1, NULL,
   NOW() + INTERVAL '3 days',
   NOW() + INTERVAL '3 days' + INTERVAL '4 hours',
   NOW() + INTERVAL '14 days',
   21.0285, 105.8542,
   'Cầu Giấy, Hà Nội',
   'Hà Nội',
   'active', false,
   'Tặng 2 điện thoại Samsung A52 còn dùng tốt tại Hà Nội.',
   NOW() - INTERVAL '2 days', NOW()),

  -- 6. Cơm từ thiện — completed, Phượng's past post (for leaderboard claims)
  ('00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0001-000000000001',
   'Cơm phần từ thiện (đã kết thúc)',
   'Đã phân phát hết 50 phần cơm trưa. Cảm ơn mọi người đã tham gia!',
   'food',
   50, 0, NULL,
   NOW() - INTERVAL '10 days',
   NOW() - INTERVAL '10 days' + INTERVAL '3 hours',
   NOW() - INTERVAL '8 days',
   10.7745, 106.7017,
   '2B Lê Lợi, Quận 1, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '15 days', NOW() - INTERVAL '8 days'),

  -- 7. Áo khoác mùa đông — completed, Mai's past post (for leaderboard claims + ratings)
  ('00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000003',
   NULL,
   'Áo khoác mùa đông',
   'Áo khoác mùa đông màu xanh navy, size M. Đã phân phát hết.',
   'clothes',
   5, 0, NULL,
   NOW() - INTERVAL '20 days',
   NOW() - INTERVAL '20 days' + INTERVAL '4 hours',
   NOW() - INTERVAL '14 days',
   10.7800, 106.7050,
   'Quận 3, TP.HCM',
   'Hồ Chí Minh',
   'completed', false, NULL,
   NOW() - INTERVAL '25 days', NOW() - INTERVAL '14 days');

-- ── 6. POST SCHEDULES ────────────────────────────────────────────────────
-- Bánh mì: recurring Mon–Sat 11:00–12:00
INSERT INTO post_schedules (post_id, day_of_week, start_time, end_time)
VALUES
  ('00000000-0000-0000-0003-000000000001', 1, '11:00', '12:00'),
  ('00000000-0000-0000-0003-000000000001', 2, '11:00', '12:00'),
  ('00000000-0000-0000-0003-000000000001', 3, '11:00', '12:00'),
  ('00000000-0000-0000-0003-000000000001', 4, '11:00', '12:00'),
  ('00000000-0000-0000-0003-000000000001', 5, '11:00', '12:00'),
  ('00000000-0000-0000-0003-000000000001', 6, '11:00', '12:00');

-- ── 7. POST IMAGES ────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0004-00000000000X
INSERT INTO post_images (id, post_id, url, position)
VALUES
  -- Bánh mì (3 ảnh)
  ('00000000-0000-0000-0004-000000000001', '00000000-0000-0000-0003-000000000001', 'https://picsum.photos/seed/banhmi_1/800/600', 0),
  ('00000000-0000-0000-0004-000000000002', '00000000-0000-0000-0003-000000000001', 'https://picsum.photos/seed/banhmi_2/800/600', 1),
  ('00000000-0000-0000-0004-000000000003', '00000000-0000-0000-0003-000000000001', 'https://picsum.photos/seed/banhmi_3/800/600', 2),
  -- Quần áo (2 ảnh)
  ('00000000-0000-0000-0004-000000000004', '00000000-0000-0000-0003-000000000002', 'https://picsum.photos/seed/quanao_1/800/600', 0),
  ('00000000-0000-0000-0004-000000000005', '00000000-0000-0000-0003-000000000002', 'https://picsum.photos/seed/quanao_2/800/600', 1),
  -- Sách (1 ảnh)
  ('00000000-0000-0000-0004-000000000006', '00000000-0000-0000-0003-000000000003', 'https://picsum.photos/seed/sachgk_1/800/600', 0),
  -- Tủ lạnh (1 ảnh)
  ('00000000-0000-0000-0004-000000000007', '00000000-0000-0000-0003-000000000004', 'https://picsum.photos/seed/tulanh_1/800/600', 0),
  -- Điện thoại (1 ảnh)
  ('00000000-0000-0000-0004-000000000008', '00000000-0000-0000-0003-000000000005', 'https://picsum.photos/seed/samsung_1/800/600', 0);

-- ── 8. CLAIMS ─────────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0005-00000000000X
--
-- Leaderboard (ranks givers by SUM of completed/picked_up claim quantities):
--   Phượng: claim 5 (qty 20) + claim 6 (qty 15) = 35 items  → Rank #1
--   Mai:    claim 3 (qty  5) + claim 4 (qty  3) =  8 items  → Rank #2
--   Dev:    claim 9 (qty  3)                    =  3 items  → Rank #3
--   Tuấn:   claim 7 (qty  1) + claim 8 (qty  1) =  2 items  → Rank #4
INSERT INTO claims (id, post_id, user_id, organization_id, quantity,
                    pickup_code, status,
                    confirmed_at, picked_up_at, cancelled_at,
                    created_at, updated_at)
VALUES
  -- 1. Dev nhận bánh mì → confirmed, có pickup code (screen 2.4.2: Claim Confirmed)
  ('00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000001',
   NULL, 2, 'A4B7C2', 'confirmed',
   NOW() - INTERVAL '1 hour', NULL, NULL,
   NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour'),

  -- 2. Mái Ấm Thiên Tâm nhận bánh mì → pending (screen 2.4.3: Who Claimed)
  ('00000000-0000-0000-0005-000000000002',
   '00000000-0000-0000-0003-000000000001',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0002-000000000001',
   5, NULL, 'pending',
   NULL, NULL, NULL,
   NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes'),

  -- 3. Hoa nhận áo khoác cũ (Mai's completed post) → completed, +5 items cho Mai
  ('00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000005',
   NULL, 5, 'X1Y2Z3', 'completed',
   NOW() - INTERVAL '22 days', NOW() - INTERVAL '21 days' + INTERVAL '2 hours', NULL,
   NOW() - INTERVAL '23 days', NOW() - INTERVAL '21 days'),

  -- 4. Dev nhận áo khoác cũ (Mai's completed post) → completed, +3 items cho Mai; dùng cho ratings + thanks
  ('00000000-0000-0000-0005-000000000004',
   '00000000-0000-0000-0003-000000000007',
   '00000000-0000-0000-0000-000000000001',
   NULL, 3, 'B3C4D5', 'completed',
   NOW() - INTERVAL '23 days', NOW() - INTERVAL '22 days' + INTERVAL '3 hours', NULL,
   NOW() - INTERVAL '24 days', NOW() - INTERVAL '22 days'),

  -- 5. Hoa nhận cơm từ thiện (Phượng's completed post) → completed, +20 items cho Phượng
  ('00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000005',
   NULL, 20, 'E5F6G7', 'completed',
   NOW() - INTERVAL '14 days', NOW() - INTERVAL '13 days', NULL,
   NOW() - INTERVAL '15 days', NOW() - INTERVAL '13 days'),

  -- 6. Mái Ấm Thiên Tâm nhận cơm (Phượng's completed post) → completed, +15 items cho Phượng
  ('00000000-0000-0000-0005-000000000006',
   '00000000-0000-0000-0003-000000000006',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0002-000000000001',
   15, 'H7I8J9', 'completed',
   NOW() - INTERVAL '15 days', NOW() - INTERVAL '14 days', NULL,
   NOW() - INTERVAL '16 days', NOW() - INTERVAL '14 days'),

  -- 7. Hoa nhận tủ lạnh (Tuấn's post) → picked_up, +1 item cho Tuấn
  ('00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0003-000000000004',
   '00000000-0000-0000-0000-000000000005',
   NULL, 1, 'K1L2M3', 'picked_up',
   NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days', NULL,
   NOW() - INTERVAL '5 days', NOW() - INTERVAL '3 days'),

  -- 8. Đức nhận điện thoại (Tuấn's post) → completed, +1 item cho Tuấn
  ('00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0003-000000000005',
   '00000000-0000-0000-0000-000000000004',
   NULL, 1, 'N4O5P6', 'completed',
   NOW() - INTERVAL '6 days', NOW() - INTERVAL '5 days', NULL,
   NOW() - INTERVAL '7 days', NOW() - INTERVAL '5 days'),

  -- 9. Đức nhận sách (Dev's post as giver) → completed, +3 items cho Dev
  ('00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0003-000000000003',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0002-000000000001',
   3, 'Q7R8S9', 'completed',
   NOW() - INTERVAL '10 days', NOW() - INTERVAL '9 days', NULL,
   NOW() - INTERVAL '11 days', NOW() - INTERVAL '9 days'),

  -- 10. Hoa nhận quần áo (Mai's active post) → pending, làm quantity_remaining = 3
  ('00000000-0000-0000-0005-000000000010',
   '00000000-0000-0000-0003-000000000002',
   '00000000-0000-0000-0000-000000000005',
   NULL, 2, NULL, 'pending',
   NULL, NULL, NULL,
   NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

-- ── 9. MESSAGES ──────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0006-00000000000X
-- Cuộc trò chuyện: Dev nhận bánh mì từ Phượng (claim 1, screen 2.1.3a/b)
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES
  ('00000000-0000-0000-0006-000000000001',
   '00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0000-000000000002',
   'Chào bạn! Bạn có thể đến lấy vào 11h–12h trưa nay không? Mình sẽ để phần sẵn cho bạn.',
   true, NOW() - INTERVAL '2 hours'),

  ('00000000-0000-0000-0006-000000000002',
   '00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'Vâng cảm ơn anh! Mình sẽ đến đúng 11h15. Mình đang ở gần đó rồi ạ.',
   true, NOW() - INTERVAL '110 minutes'),

  ('00000000-0000-0000-0006-000000000003',
   '00000000-0000-0000-0005-000000000001',
   '00000000-0000-0000-0000-000000000002',
   'Okay! Mình sẽ chuẩn bị sẵn nhé. Đến cửa tiệm hỏi anh Phượng là được.',
   false, NOW() - INTERVAL '100 minutes');

-- ── 10. RATINGS ──────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0007-00000000000X
INSERT INTO ratings (id, claim_id, rater_id, rated_id, score, comment, created_at)
VALUES
  -- Dev đánh giá Mai sau khi nhận áo khoác (claim 4)
  ('00000000-0000-0000-0007-000000000001',
   '00000000-0000-0000-0005-000000000004',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   5, 'Chị Mai rất nhiệt tình, quần áo sạch sẽ và đẹp hơn mình tưởng!',
   NOW() - INTERVAL '22 days'),

  -- Mai đánh giá Dev (claim 4)
  ('00000000-0000-0000-0007-000000000002',
   '00000000-0000-0000-0005-000000000004',
   '00000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001',
   4, 'Bạn đến đúng giờ và lịch sự. Rất vui được trao cho bạn.',
   NOW() - INTERVAL '22 days'),

  -- Hoa đánh giá Phượng sau khi nhận cơm (claim 5)
  ('00000000-0000-0000-0007-000000000003',
   '00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0000-000000000005',
   '00000000-0000-0000-0000-000000000002',
   5, 'Cơm ngon và còn nóng! Anh Phượng và nhân viên rất thân thiện.',
   NOW() - INTERVAL '13 days'),

  -- Phượng đánh giá Hoa (claim 5)
  ('00000000-0000-0000-0007-000000000004',
   '00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000005',
   5, 'Người nhận rất đúng giờ, cảm ơn bạn đã tin tưởng Bánh Mì Phượng.',
   NOW() - INTERVAL '13 days');

-- ── 11. THANKS ───────────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0008-00000000000X
INSERT INTO thanks (id, claim_id, from_user_id, to_user_id,
                    message, reaction_emoji, created_at)
VALUES
  -- Dev cảm ơn Mai sau khi nhận áo khoác (claim 4, screen 2.2.9)
  ('00000000-0000-0000-0008-000000000001',
   '00000000-0000-0000-0005-000000000004',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   'Cảm ơn chị rất nhiều! Mấy bộ quần áo rất đẹp, con mình thích lắm.',
   '🙏', NOW() - INTERVAL '22 days'),

  -- Hoa cảm ơn Phượng sau khi nhận cơm (claim 5)
  ('00000000-0000-0000-0008-000000000002',
   '00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0000-000000000005',
   '00000000-0000-0000-0000-000000000002',
   'Cảm ơn anh Phượng! Cơm rất ngon và còn nóng. Gia đình mình cảm ơn nhiều lắm.',
   '❤️', NOW() - INTERVAL '13 days');

-- ── 12a. ADDITIONAL MESSAGES ─────────────────────────────────────────────
-- Claim 2: Mái Ấm Thiên Tâm ↔ Phượng (bánh mì pending — giver inbox preview)
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES
  ('00000000-0000-0000-0006-000000000004',
   '00000000-0000-0000-0005-000000000002',
   '00000000-0000-0000-0000-000000000004',
   'Chào anh Phượng! Mái Ấm muốn nhận 5 ổ bánh mì cho các em, có thể đến 11h30 được không ạ?',
   true, NOW() - INTERVAL '25 minutes'),

  ('00000000-0000-0000-0006-000000000005',
   '00000000-0000-0000-0005-000000000002',
   '00000000-0000-0000-0000-000000000002',
   'Được bạn ơi, 11h30 mình để sẵn 5 ổ nhé. Đến hỏi anh Phượng là được.',
   false, NOW() - INTERVAL '20 minutes'),

-- Claim 9: Đức ↔ Dev (sách completed — giver inbox preview)
  ('00000000-0000-0000-0006-000000000006',
   '00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0000-000000000001',
   'Bộ sách còn mới 80%, em lấy về cho các bạn trong mái ấm nhé. Cuối tuần trước 12h anh.',
   true, NOW() - INTERVAL '12 days'),

  ('00000000-0000-0000-0006-000000000007',
   '00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0000-000000000004',
   'Dạ cảm ơn anh! Chủ nhật mình sẽ cử người đến lấy ạ.',
   true, NOW() - INTERVAL '11 days' - INTERVAL '6 hours');

-- ── 12b. ADDITIONAL RATINGS ───────────────────────────────────────────────
-- Đức đánh giá Dev sau khi nhận sách (claim 9 → cập nhật rating_avg Dev)
INSERT INTO ratings (id, claim_id, rater_id, rated_id, score, comment, created_at)
VALUES
  ('00000000-0000-0000-0007-000000000005',
   '00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001',
   5, 'Sách như mô tả, anh Dev rất nhiệt tình hỗ trợ các em trong mái ấm!',
   NOW() - INTERVAL '9 days');

-- ── 12c. ADDITIONAL THANKS ────────────────────────────────────────────────
-- Đức cảm ơn Dev (to_user_id = dev → screen 2.2.9 hiện "1 note from receivers")
INSERT INTO thanks (id, claim_id, from_user_id, to_user_id, message, reaction_emoji, created_at)
VALUES
  ('00000000-0000-0000-0008-000000000003',
   '00000000-0000-0000-0005-000000000009',
   '00000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001',
   'Anh ơi, sách rất tốt, các em trong mái ấm đang học ôn. Cảm ơn anh nhiều lắm!',
   '📚', NOW() - INTERVAL '9 days');

-- ── 12d. ADDITIONAL BUSINESSES ────────────────────────────────────────────
-- Tiệm Ngọt Dev — rejected (screen 2.2.5: badge "Từ chối")
INSERT INTO businesses (id, owner_user_id, name, category,
                        logo_url, phone, description,
                        address, latitude, longitude, city,
                        verification_status, verified_at, is_active,
                        created_at, updated_at)
VALUES
  ('00000000-0000-0000-0001-000000000003',
   '00000000-0000-0000-0000-000000000001',
   'Tiệm Ngọt Dev', 'bakery',
   'https://picsum.photos/seed/biz_ngot/200/200',
   '0901222222',
   'Tiệm bánh ngọt nhỏ, muốn đăng ký tặng bánh mỗi tuần.',
   '12 Trần Hưng Đạo, Quận 1, TP.HCM',
   10.7730, 106.6990, 'Hồ Chí Minh',
   'rejected', NULL, false,
   NOW() - INTERVAL '20 days', NOW() - INTERVAL '15 days');

-- ── 12e. ADDITIONAL ORGANIZATIONS ─────────────────────────────────────────
-- Nhóm Hỗ Trợ Cộng Đồng Dev — pending_review (screen 2.3.3: badge "Chờ xét duyệt")
INSERT INTO organizations (id, owner_user_id, name, category,
                           logo_url, phone, description, address,
                           contact_person_name, latitude, longitude, city,
                           verification_status, verified_at, is_active,
                           created_at, updated_at)
VALUES
  ('00000000-0000-0000-0002-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'Nhóm Hỗ Trợ Cộng Đồng Dev', 'social',
   'https://picsum.photos/seed/org_community/200/200',
   '0901333333',
   'Nhóm tình nguyện hỗ trợ người cao tuổi và trẻ em khó khăn trong khu phố.',
   '5 Nguyễn Thị Minh Khai, Quận 1, TP.HCM',
   'Dev Admin',
   10.7760, 106.6980, 'Hồ Chí Minh',
   'pending_review', NULL, true,
   NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days');

-- ── 12. NOTIFICATIONS ────────────────────────────────────────────────────
-- UUID scheme: 00000000-0000-0000-0009-00000000000X
INSERT INTO notifications (id, user_id, type, related_entity_id,
                           title, body, is_read, created_at)
VALUES
  -- Yêu cầu bánh mì được xác nhận (unread)
  ('00000000-0000-0000-0009-000000000001',
   '00000000-0000-0000-0000-000000000001',
   'claim_confirmed',
   '00000000-0000-0000-0005-000000000001',
   'Yêu cầu của bạn đã được xác nhận',
   'Bánh Mì Phượng đã xác nhận bạn nhận 2 ổ bánh mì. Mã pickup: A4B7C2',
   false, NOW() - INTERVAL '1 hour'),

  -- Tin nhắn mới từ Phượng (unread — badge count)
  ('00000000-0000-0000-0009-000000000002',
   '00000000-0000-0000-0000-000000000001',
   'new_message',
   '00000000-0000-0000-0005-000000000001',
   'Tin nhắn mới từ Bánh Mì Phượng',
   'Okay! Mình sẽ chuẩn bị sẵn nhé. Đến cửa tiệm hỏi anh Phượng là được.',
   false, NOW() - INTERVAL '100 minutes'),

  -- Nhận đánh giá 4 sao từ Mai (read)
  ('00000000-0000-0000-0009-000000000003',
   '00000000-0000-0000-0000-000000000001',
   'rating_received',
   '00000000-0000-0000-0007-000000000002',
   'Bạn nhận được đánh giá mới',
   'Trần Thị Mai đánh giá bạn 4 sao: "Bạn đến đúng giờ và lịch sự."',
   true, NOW() - INTERVAL '22 days');

-- ── 13. HISTORICAL COMPLETED POSTS (cho Dev User có lịch sử nhận đồ) ────
-- UUID scheme: 00000000-0000-0000-0003-00000000000{8,9,10}
INSERT INTO posts (id, user_id, business_id, title, description, category,
                   quantity, quantity_remaining, limit_per_receiver,
                   pickup_start, pickup_end, closes_at,
                   latitude, longitude, address, city,
                   status, is_recurring, ai_summary,
                   created_at, updated_at)
VALUES
  -- Post 8: Áo khoác gió (Mai, personal, completed 2 weeks ago)
  ('00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000003', NULL,
   'Áo khoác gió size L/XL còn mới 95%',
   'Mua về không mặc, còn mới 95%, size L và XL. Tặng người cần, đến lấy tại nhà Quận 3.',
   'clothes', 2, 0, NULL,
   NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days' + INTERVAL '4 hours',
   NOW() - INTERVAL '10 days',
   10.7800, 106.7050, 'Quận 3, TP.HCM', 'Hồ Chí Minh',
   'completed', false, 'Tặng 2 áo khoác gió size L/XL còn mới tại Quận 3.',
   NOW() - INTERVAL '18 days', NOW() - INTERVAL '10 days'),

  -- Post 9: Bánh mì que từ Bánh Mì Phượng (completed 3 weeks ago)
  ('00000000-0000-0000-0003-000000000009',
   '00000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0001-000000000001',
   'Bánh mì que buổi chiều — hôm nay làm dư',
   'Chiều nay tiệm làm dư 30 ổ bánh mì que, tặng miễn phí 15h–17h. Xuất trình mã pickup.',
   'food', 30, 0, 3,
   NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days' + INTERVAL '2 hours',
   NOW() - INTERVAL '19 days',
   10.7745, 106.7017, '2B Lê Lợi, Quận 1, TP.HCM', 'Hồ Chí Minh',
   'completed', false, 'Tặng 30 ổ bánh mì que từ 15h–17h tại Quận 1.',
   NOW() - INTERVAL '21 days', NOW() - INTERVAL '19 days'),

  -- Post 10: Bàn phím Logitech (Tuấn, Hà Nội, completed 1 month ago)
  ('00000000-0000-0000-0003-000000000010',
   '00000000-0000-0000-0000-000000000006', NULL,
   'Bàn phím Logitech K380 Bluetooth màu xanh',
   'Dùng 1 năm, còn tốt nguyên vẹn. Tặng người cần học/làm việc. Ở Cầu Giấy, có thể ship COD phí người nhận.',
   'tech', 1, 0, NULL,
   NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days' + INTERVAL '6 hours',
   NOW() - INTERVAL '25 days',
   21.0285, 105.8542, 'Cầu Giấy, Hà Nội', 'Hà Nội',
   'completed', false, 'Tặng bàn phím Logitech K380 Bluetooth tại Hà Nội.',
   NOW() - INTERVAL '32 days', NOW() - INTERVAL '25 days');

-- ── 13a. POST IMAGES cho posts mới ───────────────────────────────────────
INSERT INTO post_images (id, post_id, url, position)
VALUES
  ('00000000-0000-0000-0004-000000000009', '00000000-0000-0000-0003-000000000008', 'https://picsum.photos/seed/jacket_windbreaker/800/600', 0),
  ('00000000-0000-0000-0004-000000000010', '00000000-0000-0000-0003-000000000009', 'https://picsum.photos/seed/banhmi_que/800/600', 0),
  ('00000000-0000-0000-0004-000000000011', '00000000-0000-0000-0003-000000000010', 'https://picsum.photos/seed/keyboard_logitech/800/600', 0);

-- ── 14. HISTORICAL CLAIMS cho Dev User (receiver) ────────────────────────
-- Dev User nhận đồ từ 3 givers khác nhau → shows "Done" section in Messages
INSERT INTO claims (id, post_id, user_id, organization_id, quantity,
                    pickup_code, status,
                    confirmed_at, picked_up_at, cancelled_at,
                    created_at, updated_at)
VALUES
  -- 11. Dev nhận áo khoác gió từ Mai (picked_up)
  ('00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0003-000000000008',
   '00000000-0000-0000-0000-000000000001',
   NULL, 1, 'D9E0F1', 'picked_up',
   NOW() - INTERVAL '16 days', NOW() - INTERVAL '15 days', NULL,
   NOW() - INTERVAL '17 days', NOW() - INTERVAL '15 days'),

  -- 12. Dev nhận bánh mì que từ Bánh Mì Phượng (picked_up)
  ('00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0003-000000000009',
   '00000000-0000-0000-0000-000000000001',
   NULL, 3, 'G2H3I4', 'picked_up',
   NOW() - INTERVAL '21 days', NOW() - INTERVAL '20 days', NULL,
   NOW() - INTERVAL '22 days', NOW() - INTERVAL '20 days'),

  -- 13. Dev nhận bàn phím từ Tuấn (shipped, picked_up 1 month ago)
  ('00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0003-000000000010',
   '00000000-0000-0000-0000-000000000001',
   NULL, 1, 'J5K6L7', 'picked_up',
   NOW() - INTERVAL '31 days', NOW() - INTERVAL '30 days', NULL,
   NOW() - INTERVAL '32 days', NOW() - INTERVAL '30 days');

-- ── 15. MESSAGES cho claims hiện tại CHƯA CÓ conversation ───────────────
-- Claim 3: Hoa ↔ Mai (áo khoác mùa đông, completed)
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES
  ('00000000-0000-0000-0006-000000000008',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000005',
   'Chị ơi áo size S–M có vừa không ạ? Mình hơi nhỏ người.',
   true, NOW() - INTERVAL '24 days'),
  ('00000000-0000-0000-0006-000000000009',
   '00000000-0000-0000-0005-000000000003',
   '00000000-0000-0000-0000-000000000003',
   'Áo size M thôi bạn ơi, dáng hơi rộng thoải mái mặc lớp ngoài nhé. Sáng chủ nhật đến lấy được không?',
   true, NOW() - INTERVAL '23 days' - INTERVAL '22 hours'),

-- Claim 5: Hoa ↔ Phượng (cơm từ thiện, completed)
  ('00000000-0000-0000-0006-000000000010',
   '00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0000-000000000005',
   'Anh ơi mình đến nhận cho 4 người được không? Nhà mình gần đây ạ.',
   true, NOW() - INTERVAL '15 days'),
  ('00000000-0000-0000-0006-000000000011',
   '00000000-0000-0000-0005-000000000005',
   '00000000-0000-0000-0000-000000000002',
   'Được bạn! Nhớ đến trước 12h nhé. Đến hỏi anh Phượng là có ngay.',
   true, NOW() - INTERVAL '14 days' - INTERVAL '22 hours'),

-- Claim 7: Hoa ↔ Tuấn (tủ lạnh, picked_up)
  ('00000000-0000-0000-0006-000000000012',
   '00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0000-000000000005',
   'Anh Tuấn ơi tủ lạnh còn không? Mình cần lắm ạ.',
   true, NOW() - INTERVAL '5 days'),
  ('00000000-0000-0000-0006-000000000013',
   '00000000-0000-0000-0005-000000000007',
   '00000000-0000-0000-0000-000000000006',
   'Còn bạn! Tủ nặng nên bạn thuê xe tải nhỏ nhé. Mình có thể chờ đến cuối tuần.',
   true, NOW() - INTERVAL '4 days' - INTERVAL '20 hours'),

-- Claim 8: Đức ↔ Tuấn (điện thoại, completed)
  ('00000000-0000-0000-0006-000000000014',
   '00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0000-000000000004',
   'Anh Tuấn ơi còn 1 máy nữa không? Mình cần cho tình nguyện viên dùng.',
   true, NOW() - INTERVAL '7 days'),
  ('00000000-0000-0000-0006-000000000015',
   '00000000-0000-0000-0005-000000000008',
   '00000000-0000-0000-0000-000000000006',
   'Còn đúng 1 cái! Mình để sẵn, bạn xuống Cầu Giấy lấy nhé, nhắn trước 1 tiếng.',
   true, NOW() - INTERVAL '6 days' - INTERVAL '23 hours');

-- ── 15a. MESSAGES cho new claims (Dev User history) ──────────────────────
INSERT INTO messages (id, claim_id, sender_id, content, is_read, created_at)
VALUES
  -- Claim 11: Dev ↔ Mai (áo khoác gió)
  ('00000000-0000-0000-0006-000000000016',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000001',
   'Chị Mai ơi còn áo size L không ạ?',
   true, NOW() - INTERVAL '17 days'),
  ('00000000-0000-0000-0006-000000000017',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000003',
   'Còn đúng 1 cái size L! Chiều 5h bạn lấy được không?',
   true, NOW() - INTERVAL '16 days' - INTERVAL '23 hours'),
  ('00000000-0000-0000-0006-000000000018',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000001',
   'Dạ được chị! Em đến đúng 5h. Cảm ơn chị nhiều!',
   true, NOW() - INTERVAL '16 days' - INTERVAL '22 hours'),

  -- Claim 12: Dev ↔ Phượng (bánh mì que)
  ('00000000-0000-0000-0006-000000000019',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000002',
   'Bạn ơi chiều nay qua lấy nhé, 15h–17h thôi, hết là hết.',
   true, NOW() - INTERVAL '22 days'),
  ('00000000-0000-0000-0006-000000000020',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000001',
   'Dạ anh, em đến lúc 15h30 ạ. Cảm ơn anh Phượng!',
   true, NOW() - INTERVAL '21 days' - INTERVAL '22 hours'),
  ('00000000-0000-0000-0006-000000000021',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000002',
   'Okay! Mình để sẵn 3 ổ nhé 👍',
   true, NOW() - INTERVAL '21 days' - INTERVAL '20 hours'),

  -- Claim 13: Dev ↔ Tuấn (bàn phím)
  ('00000000-0000-0000-0006-000000000022',
   '00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0000-000000000001',
   'Anh Tuấn ơi bàn phím còn không ạ? Mình đang cần làm việc từ xa.',
   true, NOW() - INTERVAL '32 days'),
  ('00000000-0000-0000-0006-000000000023',
   '00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0000-000000000006',
   'Còn bạn! Mình ship COD được nếu bạn ở HCM, phí ship bạn chịu nhé.',
   true, NOW() - INTERVAL '31 days' - INTERVAL '22 hours');

-- ── 16. RATINGS cho new claims ────────────────────────────────────────────
INSERT INTO ratings (id, claim_id, rater_id, rated_id, score, comment, created_at)
VALUES
  -- Dev → Mai (claim 11)
  ('00000000-0000-0000-0007-000000000006',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   5, 'Áo đúng mô tả, chị Mai nhiệt tình và đúng hẹn. Cảm ơn chị!',
   NOW() - INTERVAL '15 days'),
  -- Mai → Dev (claim 11)
  ('00000000-0000-0000-0007-000000000007',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001',
   5, 'Bạn đến đúng giờ, lịch sự. Mừng vì đồ có chủ tốt!',
   NOW() - INTERVAL '15 days'),
  -- Dev → Phượng (claim 12)
  ('00000000-0000-0000-0007-000000000008',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000002',
   5, 'Bánh mì giòn ngon, anh Phượng và nhân viên rất thân thiện. Sẽ quay lại!',
   NOW() - INTERVAL '20 days'),
  -- Dev → Tuấn (claim 13)
  ('00000000-0000-0000-0007-000000000009',
   '00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000006',
   5, 'Bàn phím hoạt động hoàn hảo, anh Tuấn hỗ trợ ship tận nơi. Cảm ơn anh!',
   NOW() - INTERVAL '30 days'),
  -- Tuấn → Dev (claim 13)
  ('00000000-0000-0000-0007-000000000010',
   '00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0000-000000000006',
   '00000000-0000-0000-0000-000000000001',
   5, 'Bạn rất dễ trao đổi, thanh toán ship nhanh. Cảm ơn đã nhận đồ!',
   NOW() - INTERVAL '30 days');

-- ── 17. THANKS cho new claims ─────────────────────────────────────────────
INSERT INTO thanks (id, claim_id, from_user_id, to_user_id,
                    message, reaction_emoji, created_at)
VALUES
  -- Dev cảm ơn Mai (claim 11)
  ('00000000-0000-0000-0008-000000000004',
   '00000000-0000-0000-0005-000000000011',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000003',
   'Cảm ơn chị Mai! Áo mặc vừa vặn và đẹp hơn mình nghĩ nhiều.',
   '🙏', NOW() - INTERVAL '15 days'),
  -- Dev cảm ơn Phượng (claim 12)
  ('00000000-0000-0000-0008-000000000005',
   '00000000-0000-0000-0005-000000000012',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000002',
   'Cảm ơn anh Phượng! Bánh mì ngon lắm, cả nhà mình thích.',
   '🍞', NOW() - INTERVAL '20 days'),
  -- Dev cảm ơn Tuấn (claim 13)
  ('00000000-0000-0000-0008-000000000006',
   '00000000-0000-0000-0005-000000000013',
   '00000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000006',
   'Bàn phím tuyệt vời anh ơi! Giúp mình làm việc hiệu quả hơn nhiều. Cảm ơn anh!',
   '⌨️', NOW() - INTERVAL '30 days');

-- ── 18. ADDITIONAL NOTIFICATIONS ─────────────────────────────────────────
INSERT INTO notifications (id, user_id, type, related_entity_id,
                           title, body, is_read, created_at)
VALUES
  -- Dev nhận đánh giá từ Tuấn (claim 13)
  ('00000000-0000-0000-0009-000000000004',
   '00000000-0000-0000-0000-000000000001',
   'rating_received',
   '00000000-0000-0000-0007-000000000010',
   'Bạn nhận được đánh giá mới',
   'Hoàng Minh Tuấn đánh giá bạn 5 sao: "Rất dễ trao đổi, thanh toán ship nhanh."',
   true, NOW() - INTERVAL '30 days'),
  -- Dev nhận đánh giá từ Mai (claim 11)
  ('00000000-0000-0000-0009-000000000005',
   '00000000-0000-0000-0000-000000000001',
   'rating_received',
   '00000000-0000-0000-0007-000000000007',
   'Bạn nhận được đánh giá mới',
   'Trần Thị Mai đánh giá bạn 5 sao: "Đến đúng giờ, lịch sự. Mừng vì đồ có chủ tốt!"',
   true, NOW() - INTERVAL '15 days'),
  -- Phượng nhận claim mới từ Mái Ấm (claim 2, unread)
  ('00000000-0000-0000-0009-000000000006',
   '00000000-0000-0000-0000-000000000002',
   'claim_created',
   '00000000-0000-0000-0005-000000000002',
   'Mái Ấm Thiên Tâm muốn nhận bánh mì',
   'Mái Ấm Thiên Tâm đăng ký nhận 5 ổ bánh mì cho các em nhỏ.',
   false, NOW() - INTERVAL '30 minutes'),
  -- Mai nhận claim mới từ Dev (claim 11)
  ('00000000-0000-0000-0009-000000000007',
   '00000000-0000-0000-0000-000000000003',
   'claim_created',
   '00000000-0000-0000-0005-000000000011',
   'Có người muốn nhận áo khoác của bạn',
   'Dev User đăng ký nhận 1 áo khoác gió size L.',
   true, NOW() - INTERVAL '17 days');

COMMIT;
