# What's for Dinner? 🍳

Tell the app what's in your kitchen — it finds recipes ranked by how much of
it you can already use, closest match first.

This is **Phase 1 (MVP)** per the project spec: Home → My Kitchen → Add
Ingredients → Find Dinner → Matching → Results → Recipe Details. Favorites,
shopping list, meal planner, auth, and user-submitted recipes are designed
for but intentionally left out so the core loop ships first.

```
whats-for-dinner/
├── backend/     Node.js + Express + PostgreSQL API
└── frontend/    Flutter app (Riverpod for state)
```

## 1. Backend setup

**Requirements:** Node.js 18+, PostgreSQL running locally (or a hosted URL).

```bash
cd backend
npm install
cp .env.example .env
# edit .env with your actual DATABASE_URL if it differs
```

Create the database and load the schema:

```bash
createdb whats_for_dinner
psql -d whats_for_dinner -f src/schema.sql
```

Seed it with ~10 starter recipes (including a few Ethiopian dishes —
Shiro, Misir Wot, Chicken Tibs — as a differentiator from generic recipe apps):

```bash
npm run seed
```

Run the server:

```bash
npm run dev
# -> What's for Dinner? API running on http://localhost:4000
```

Quick check:

```bash
curl http://localhost:4000/api/health
curl http://localhost:4000/api/recipes
```

### API summary

| Method | Path                  | Purpose                                   |
|--------|-----------------------|--------------------------------------------|
| GET    | /api/recipes          | List/search recipes                       |
| GET    | /api/recipes/:id      | Full recipe detail (ingredients, steps)   |
| POST   | /api/recipes/match    | Rank recipes by ingredient match %        |
| GET    | /api/kitchen          | Get the demo user's kitchen contents      |
| POST   | /api/kitchen          | Add/update an ingredient in the kitchen   |
| DELETE | /api/kitchen/:id      | Remove an ingredient from the kitchen     |

The matching algorithm (`backend/src/services/matching.js`) weights
*required* ingredients 3x higher than *optional* ones, so a recipe missing a
garnish still scores well, but one missing a core ingredient doesn't.

There's no auth yet — everything is scoped to a single `demo-user`. Adding
real accounts is a Version 2 step (see the original spec).

## 2. Frontend setup

**Requirements:** Flutter SDK 3.3+.

```bash
cd frontend
flutter pub get
```

By default the app points at `http://10.0.2.2:4000/api`, which is the
correct address for the **Android emulator** to reach your machine's
localhost. Adjust for your target:

```bash
# iOS simulator / macOS / web / desktop — localhost works directly
flutter run --dart-define=API_BASE_URL=http://localhost:4000/api

# Physical device — use your machine's LAN IP
flutter run --dart-define=API_BASE_URL=http://192.168.1.23:4000/api
```

Or just:

```bash
flutter run
```

if you're on the Android emulator with the backend running locally.

## 3. What you'll see

1. **Home** — shows how many ingredients are in your kitchen, with a
   "Find Dinner" button.
2. **My Kitchen** — add ingredients (name, category, quantity, unit) via a
   bottom sheet with quick-add chips for common items.
3. **Find Dinner** — calls `POST /api/recipes/match` with your kitchen's
   ingredient IDs and shows every recipe sorted by match %, with a progress
   bar and "BEST MATCH" badge on the top result.
4. **Recipe Details** — full ingredient list (required vs optional) and
   numbered instructions.

## 4. Next steps (Version 2+, from the original spec)

- Auth (JWT) so `user_id` is real instead of a hardcoded demo user
- Favorites, Shopping List, Meal Planner
- Search and category browsing
- Dietary preferences / allergies filtering the match results
- User-submitted recipes (moderation, likes, reviews)
- AI recipe generator / ingredient photo scanning

Each of these slots cleanly into the existing feature-based folder structure
(`frontend/lib/features/<name>/{models,providers,screens}` and
`backend/src/{routes,controllers}`).
