# Thanks App — Screen-by-Screen Description

> Source: prototype at https://minhidea.com/#thanks  
> Purpose: input for any LLM or developer to fully understand every screen, user flow, and content of the Thanks app without seeing the prototype.

---

## Overview

**Thanks** is a community item-sharing app for Vietnam. Users can give away unused items for free, or browse and claim items near them. There are two primary user roles:
- **Giver** — posts items they want to give away (can be a personal user or a business)
- **Receiver** — browses and claims free items nearby (can be a personal user or a nonprofit organisation)

A single account can act as both Giver and Receiver.

---

## Section 1 — Non-Logged-In (Unauthenticated)

These screens are visible before the user creates an account or logs in.

---

### 1.1 Logged-Out Home / Entry Screen (Screen 2.1.5)

**Purpose:** First screen a new user sees. Prompts them to choose a role before signing up.

**Layout — top to bottom:**
- App logo / name: `thanks!`
- Headline text: invites user to join the community
- Two large primary buttons:
  - `Receive` — for users who want to browse and claim free items
  - `Give` — for users who want to share unused items
- Secondary link: `Log in` (for returning users)
- Footer: agreement text linking to Terms of Service and Community Guidelines

**User actions:**
- Tap `Receive` → goes to Sign Up screen with role pre-set to "Receiver"
- Tap `Give` → goes to Sign Up screen with role pre-set to "Giver"
- Tap `Log in` → goes to Login screen

---

### 1.2 Sign Up — Auth Method (Screen 2.1.6)

**Purpose:** New user selects how they want to authenticate.

**Layout — top to bottom:**
- Back arrow (top left)
- Role indicator text: `Signing up as Receiver` or `Signing up as Giver` (pre-filled from previous screen)
- Section: `Continue with`
  - Button: `Zalo` (with Zalo logo)
  - Button: `Google` (with Google logo)
  - Button: `Facebook` (with Facebook logo)
  - Button: `Apple` (with Apple logo)
- Divider: `or`
- Input field: `Phone number` (Vietnamese format, e.g. 09xxxxxxxx)
- Button: `Continue` (enabled when phone is filled)
- Footer: `By continuing, you agree to our Terms and Community Guidelines`

**User actions:**
- Tap any social button → OAuth flow for that provider
- Enter phone + tap Continue → OTP verification flow

---

### 1.3 Home Feed — Unauthenticated Browse

**Purpose:** Non-logged-in users can browse items but cannot claim them. Same layout as the logged-in home feed but claim buttons are replaced with a prompt to sign up.

*(Full layout described in Section 2.1 — Home Feed, which is identical visually.)*

---

## Section 2 — Giver (Logged In)

A logged-in Giver can post items, manage their listings, view who has claimed their items, chat with claimants, and track their impact.

---

### 2.1 Home Feed (Screen 2.1.1)

**Purpose:** Main discovery screen. Shows free items available near the user.

**Layout — top to bottom:**

**App Bar:**
- Left: location pin icon + city name (`HCMC`) + dropdown arrow → tapping opens city/district selector
- Right: notification bell icon (with optional badge for unread)

**Search Bar (below app bar):**
- Placeholder text: `Search bread, books, anything…`
- Search icon on left

**Category Filter Row (horizontal scroll):**
- Pills/chips: `All` · `Food` · `Clothes` · `Furniture` · `Tech` · `Books`
- Active pill is highlighted in primary green
- Tapping a pill filters the item grid below

**Top Business Givers Section:**
- Section title: `Top Business Givers`
- Link on right: `Xem thêm` (See more) → goes to Givers Leaderboard
- Horizontal scrollable row of giver cards, each showing:
  - Circular avatar with business initial
  - Rank badge (gold circle with `#1`, `#2`, etc.)
  - Verified checkmark icon (blue/green)
  - Business name (truncated if long)
  - Star rating (e.g. `⭐ 4.9`)
  - Items count (e.g. `234 items`)

**Section header for item grid:**
- Left: `Đồ miễn phí gần bạn` (Free items near you)
- Right: item count (e.g. `6 món`)

**Item Grid (2 columns):**
Each item card contains:
- Image placeholder / photo (top half of card)
- `FREE` badge (green, top-right corner of image)
- Item title (bold, max 2 lines)
- Quantity remaining: `X/Y còn lại` (e.g. `5/10 còn lại`)
- Distance + district: `📍 0.3 km · Quận 1`
- Pickup window: `🕐 Hôm nay 8–10AM`
- Giver row: avatar initial circle + giver name + verified icon (if verified)

**Bottom Navigation Bar (4 tabs):**
- `Home` (house icon) — currently active
- `Givers` (heart icon)
- `Messages` (chat bubble icon) — shows badge with unread count (e.g. `3`)
- `Profile` (person icon)

---

### 2.2 Givers Leaderboard (Screen 2.1.2)

**Purpose:** Shows ranked list of top givers. Motivates giving through social recognition.

**Layout:**
- App bar: location filter (`HCMC`) + dropdown
- Filter toggle bar: `All` · `Business` · `Personal` · `Top`
- Ranked list (10+ entries), each row:
  - Rank number on left (e.g. `#1`)
  - Circular avatar
  - Verified badge (if applicable)
  - Giver name
  - Star rating + review count
  - Total items given
  - If viewing own rank: `You're #3` highlight indicator
- Bottom navigation (same 4 tabs)

---

### 2.3 Messages — Giver View (Screen 2.1.3b)

**Purpose:** Giver manages incoming messages from people who claimed their items.

**Layout:**
- App bar title: `Messages`
- Grouped by identity (Personal section, then each Business section)
- Each group shows:
  - Group header: identity name + total active conversations count
  - Item cards within the group, each showing:
    - Item thumbnail (small, left)
    - Item title
    - Timestamp (time elapsed, e.g. `2h ago`)
    - Unread message badge (number)
    - Message preview (first line of latest message from claimant)
    - Quantity info: `available X / total Y`
    - Row of claimant avatars (stacked circles) + `+N` if more than 3
- Bottom navigation

---

### 2.4 Profile — Personal Giver (Screen 2.1.4a)

**Purpose:** Giver's own profile overview.

**Layout:**
- Large circular avatar (top center)
- Name (bold)
- Role badge: `Giver`
- Stats row: `Items given: 45` · `⭐ 4.7` · `(23 ratings)`
- Action button: `+ Item` (green, primary) → opens Submit Item flow
- Section: `My items` with count label (`2 active / 5 closed`) → navigates to My Items screen
- Section: `Thanks` with count (`9 notes`) → navigates to Thanks & Ratings screen
- Link: `Manage businesses` → navigates to Manage Businesses screen
- Account section:
  - `Settings` → navigates to Settings screen
  - `Sign out`
- Bottom navigation

---

### 2.5 Profile — Giver with Multiple Businesses (Screen 2.1.4b)

**Purpose:** Same as 2.4, but with additional business identity cards below the personal section.

**Extra section (repeats for each business):**
- Business logo / avatar
- Verification badge + category label (e.g. `Food & Beverage`)
- Business address (short form)
- `+ Item` button
- Business stats: `items given` · `rating` · `rank`
- Link to manage that specific business

---

### 2.6 Settings (Screen 2.1.4d)

**Purpose:** User account and app settings.

**Layout (grouped sections):**

**Account:**
- `Address` — current address, editable
- `Phone` — current phone number, editable
- `Email` — current email, editable
- `Password` — shows `Last changed: [date]`, tap to change

**App:**
- `Notifications` — toggle or navigate to notification preferences
- `Language` — current language (e.g. Vietnamese), tap to change

**Privacy:**
- Links to privacy preferences

**About:**
- `Terms of Service` (link)
- `Community Guidelines` (link)
- `Version` — app version number

---

### 2.7 Submit Item — Step 1 of 2 (Screen 2.2.7)

**Purpose:** Giver uploads photos and writes a title and description for the item they want to give.

**Layout:**
- Top bar: `✕` close button (left) · `Save draft` link (right)
- Section: `Photos`
  - Upload button with camera icon: `Add photos`
  - Once uploaded: photo thumbnails with `✕` remove button on each
  - First photo is labeled `Main photo`
- Field: `Title` — text input, e.g. `Bánh mì thịt`
- Field: `Description`
  - Text area (multi-line)
  - Below: `✨ AI-generated` label + `Regenerate` button (LLM suggests a description based on title and category)
- Bottom: step indicator `STEP 1 OF 2` + `Next →` button

---

### 2.8 Submit Item — Step 2 of 2 (Screen 2.2.8)

**Purpose:** Giver fills in logistics details before posting.

**Layout:**
- Top bar: `← Back` · `Save draft`
- Field: `Category`
  - AI-suggested category shown (e.g. `Food`)
  - `Change` link to manually override
- Field: `Quantity`
  - Number input for total quantity
  - Sub-field: `Limit per receiver` (e.g. `1`)
- Field: `Pickup window`
  - Day selector: checkboxes for Mon/Tue/Wed/Thu/Fri/Sat/Sun
  - Time range: start time and end time pickers
- Field: `Location`
  - Map thumbnail + address line
  - `Change` link to update pickup address
- Field: `Post duration`
  - Options: `1 day` · `3 days` · `1 week` · `2 weeks` · `1 month`
  - AI suggestion highlighted (e.g. `1 week` for food items)
- Bottom: step indicator `STEP 2 OF 2` + `Post gift` primary button

---

### 2.9 My Items — Personal (Screen 2.2.3)

**Purpose:** Giver manages their own item listings.

**Layout:**
- App bar: `← Back` · title `My Items`
- Personal info row: avatar + name + `Total: N items`
- Tab bar: `Recent` · `Available` · `Completed`
- Item list (each row):
  - Item thumbnail
  - Title + category label
  - Status badge: `ACTIVE` / `COMPLETED` / `CANCELLED`
  - Quantity: `X claimed / Y total`
  - Claimant count + stacked avatars
  - Pickup window summary
- Floating action button: `+ Submit item`

---

### 2.10 My Items — Business (Screen 2.2.4)

**Purpose:** Same as 2.9 but scoped to a specific business identity.

**Differences from Personal:**
- Header shows business name/logo instead of personal name
- All items listed belong to that business

---

### 2.11 Claimants List (Screen 2.4.3)

**Purpose:** Giver views all people who claimed a specific item.

**Layout:**
- App bar: `← Back` · item title
- Summary row: `Claimed: X · Available: Y · Closes in: Z days`
- Claimant list (each row):
  - Avatar + name
  - Timestamp (`claimed 2h ago`)
  - Rating + claim history count
  - Status badge: `CLAIMED` or `PICKED UP`
  - Quantity claimed (e.g. `×2`)
- Expandable section: `+ N more claimants`

---

### 2.12 Manage Businesses (Screen 2.2.5)

**Purpose:** Giver manages all their business identities.

**Layout:**
- App bar: `← Back` · title `My Businesses`
- Business cards list, each showing:
  - Business logo
  - Business name
  - Category (e.g. `Bakery`)
  - Address (short form)
  - Verification status badge: `VERIFIED` / `PENDING REVIEW`
  - Chevron `→` to open that business's edit/detail page
- Button at bottom: `+ Add business`

---

### 2.13 Add Business (Screen 2.2.6)

**Purpose:** Giver registers a new business identity for verification.

**Layout (form):**
- App bar: `← Back` · title `Add Business`
- Field: `Logo` — image upload button
- Field: `Business name` — text input
- Field: `Category` — dropdown (Food & Beverage / Retail / Services / etc.)
- Field: `Address` — text input with map lookup
- Field: `Phone number` — text input
- Field: `Description` — optional text area
- Info box: `Admin review takes 1–3 business days`
- Button: `Submit for review` (primary, full-width)

---

### 2.14 Thanks & Ratings — Giver Impact (Screen 2.2.9)

**Purpose:** Giver sees their overall impact and thank-you notes from receivers.

**Layout:**
- App bar: `← Back` · title `Your Impact`
- Impact stats cards:
  - `Items given: 45`
  - `People helped: 120`
  - `Weight saved: ~18 kg`
- Rating display: `⭐ 4.7 · 23 ratings`
- Achievement badge: `Top 10% of givers this month`
- Section: `Thank-you notes`
  - List of recent notes, each showing:
    - Receiver avatar + name
    - Heart/like icon
    - Quote excerpt (first 1–2 lines of their message)
    - Context: item name + claim date
    - Timestamp
  - `See all` link at bottom

---

## Section 3 — Receiver (Logged In)

A logged-in Receiver can browse items, claim them, communicate with givers, and manage their claim history.

---

### 3.1 Home Feed (Screen 2.1.1)

Same screen as Section 2.1, but:
- `Pickup` / claim buttons are active (not locked behind sign-up prompt)
- User sees their own claim history in Messages tab

---

### 3.2 Item Detail (Screen 2.4.1)

**Purpose:** Receiver views full details of a specific item before claiming.

**Layout — top to bottom:**
- Top bar: `← Back` · share icon (top right)
- Image carousel: full-width photo area with `1/3` page indicator and left/right arrow buttons
- Item title (large, bold)
- `FREE` badge (green pill, prominent)
- Meta row: category label · distance · district name
- Full description text (multi-paragraph)
- Status pill: `AVAILABLE` (green) or `CLAIMED` (grey)
- Quantity section:
  - `Remaining: X of Y`
  - `Limit: Z per person`
- Closing timeline: `Closes in 10 days`
- Location section:
  - Map thumbnail
  - Full address (only visible if item is active)
- Pickup window: `Mon–Tue · 14h–18h`
- Giver card (tappable, links to Giver Public Profile):
  - Avatar + name + verified badge
  - Stats: `⭐ 4.9 · 234 items given`
- Primary CTA button: `I take this` (full-width green button)

---

### 3.3 Claim Confirmed (Screen 2.4.2)

**Purpose:** Confirmation screen shown immediately after a receiver successfully claims an item.

**Layout — top to bottom:**
- Large checkmark icon (green circle, top center)
- Headline: `Claim confirmed!`
- Subtext: `The giver has been notified`
- **Pickup code display:** large digits `4 · 2 · 8 · 6` (4-digit code receiver shows to giver at pickup)
- Item summary:
  - Item name
  - Quantity claimed
- Logistics block:
  - Pickup window: day(s) + time range
  - Location + distance + estimated drive time
- Giver card:
  - Avatar + name + verified badge
  - Estimated response time: `Usually responds within 1 hour`
- Action buttons:
  - `📞 Call` — in-app call to giver
  - `💬 Message` — opens chat thread for this claim
- Privacy note: `Personal giver — exact address shared only at pickup`
- Secondary action: `Cancel claim` (text link, grey)
- Bottom link: `Get directions` (opens map app)

---

### 3.4 Messages — Receiver View (Screen 2.1.3a)

**Purpose:** Receiver manages all their active and completed claim conversations.

**Layout:**
- App bar title: `Messages`
- Tab bar: `My Claims` with sub-counts: `Active (1)` · `Done (8)`
- Optional system banner (e.g. platform announcements)
- **Active section:**
  - Claim card(s), each showing:
    - Item thumbnail (left)
    - Giver name + item title
    - Time elapsed since claim (`2h ago`)
    - Status badge: `ACTIVE`
    - ETA or pickup window reminder
    - Unread message indicator (dot or count)
    - Message preview: first line of latest message from giver
- **Done section:**
  - Past claim rows (condensed), each showing:
    - Item thumbnail + title
    - Giver name
    - Date completed
    - Rating given (stars, if already rated)
- Bottom navigation

---

### 3.5 Profile — Receiver (Screen 2.1.4c)

**Purpose:** Receiver's own profile.

**Layout:**
- Large circular avatar (top center)
- Name (bold)
- Role badge: `Receiver`
- Stats row: `Claims: 9` · `⭐ 4.8` · `(14 ratings)`
- Section: `My claims` with count (`1 active / 8 completed`) → navigates to claims history
- Section: `Thanks sent` with count (`6 notes`) → navigates to thank-you notes sent
- If part of an organisation: organisation management section
- Account section:
  - `Settings` → same Settings screen as Givers
  - `Sign out`
- Bottom navigation

---

### 3.6 Manage Organizations (Screen 2.3.3)

**Purpose:** Receiver manages non-profit or mutual-aid organisations they represent.

**Layout:**
- App bar: `← Back` · title `My Organizations`
- Organisation cards list, each showing:
  - Organisation logo
  - Name
  - Type (e.g. `Food Bank`, `Mutual Aid`)
  - Location (short form)
  - Stats: `Deliveries: 45` · `People served: 320`
  - Verification status: `VERIFIED` / `PENDING`
  - Chevron `→`
- Button at bottom: `+ Add organization`

---

### 3.7 Add Organization (Screen 2.3.4)

**Purpose:** Receiver registers a new organisation for verification.

**Layout (form):**
- App bar: `← Back` · title `Add Organization`
- Field: `Logo` — image upload
- Field: `Organization name` — text input
- Field: `Type` — dropdown (Food Bank / Mutual Aid / Shelter / etc.)
- Field: `Mission / Description` — text area
- Field: `Address` — text input with map
- Field: `Contact phone`
- Field: `Operational photos` — multi-image upload (to prove legitimacy)
- Field: `Registration document` — optional file upload (PDF)
- Info box: `Admin review takes 1–3 business days`
- Button: `Submit for review`

---

## Section 4 — Shared / Discovery Screens

These screens are accessible to both Givers and Receivers.

---

### 4.1 Giver Public Profile — Business (Screen 2.2.1)

**Purpose:** Any user can view a business giver's public profile.

**Layout:**
- App bar: `← Back` · `⋯` more options (report, follow)
- Verification badge + business name + category
- Location + distance from viewer
- Stats row: `Items given: 234` · `⭐ 4.9` · `#1 in HCMC`
- Address note: `Full address visible after you claim`
- Tab bar: `Recent (5)` · `Available` · `Completed`
- Item list per tab, each row:
  - Item title + category
  - Quantity remaining
  - Pickup window
  - Row of claimant avatars (who has claimed)
  - `+ N more claimants` expandable

---

### 4.2 Giver Public Profile — Personal (Screen 2.2.2)

**Purpose:** Same as 4.1 but for a personal (non-business) giver.

**Differences:**
- No business verification badge (may have personal verified badge)
- No category label
- Same tab structure (Recent / Available / Completed)

---

### 4.3 Receiver Public Profile — Personal (Screen 2.3.1)

**Purpose:** Giver can tap a claimant's name to see their receiver profile.

**Layout:**
- App bar: `← Back` · `⋯` more options (report)
- Avatar + name
- Stats: `Claims: 9` · `⭐ 4.8` · `No-shows: 0`
- Location: city/district only (exact address private)
- Trust badge: `Reliable Receiver` with reasoning text
- Recent ratings / testimonies (2–3 lines of text from givers)

---

### 4.4 Receiver Public Profile — Organization (Screen 2.3.2)

**Purpose:** Givers can see the profile of a non-profit organisation.

**Layout:**
- Verification badge + org logo + name + type
- Stats: `Deliveries: 45` · `People served: 320` · `⭐ 4.9`
- `About` section: mission text paragraph
- Admin-verified indicator
- Volunteer / staff count or info (if available)

---

## Data Models Summary (for API design reference)

| Entity | Key Fields |
|---|---|
| **User** | id, phone, name, avatar_url, role (giver/receiver/both), is_verified, rating_avg, rating_count |
| **Business** | id, owner_id, name, category, address, logo_url, is_verified, rating_avg, items_given_count |
| **Organization** | id, owner_id, name, type, mission, address, logo_url, is_verified, deliveries_count, people_served |
| **Post** | id, user_id, business_id (optional), title, description, category, quantity, quantity_remaining, pickup_days, pickup_start_time, pickup_end_time, address, lat, lng, status, closes_at |
| **PostImage** | id, post_id, url, position |
| **Claim** | id, post_id, user_id, quantity, pickup_code, status (pending/confirmed/completed/cancelled) |
| **Message** | id, claim_id, sender_id, content, created_at |
| **Rating** | id, claim_id, rater_id, rated_id, score (1–5), comment |
