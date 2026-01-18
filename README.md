# AncientWhiteArmyVet RPG Tools

An old-school web app with a modern goal: **make game-night logistics boring**.

This project is intentionally “no-framework glamour shots”: it’s a multi-page HTML/CSS/JS UI served by a single Express server that also exposes a REST API. It includes JWT auth, MySQL persistence, and pragmatic deployment shape.

If you’re an employer or recruiter: this repo is a readable demonstration of full-stack fundamentals (HTTP, auth, database, and deployment) where the code is the product—no scaffolding camouflage.

## TL;DR

- **Single-origin app**: Express serves both UI and `/api/*`.
- **Real auth**: bcrypt password hashing + JWT access/refresh tokens.
- **MySQL-backed**: users + characters (tables auto-created on boot).
- **Vanilla front-end**: multi-page UI + `fetch` helpers (a tiny “client SDK”).
- **Production-ready shape**: reverse proxy friendly; can bind Node to localhost.

## What this demonstrates (for hiring teams)

This codebase is a useful “skills audit” because it touches several real-world seams:

- **Backend design**: route/controller/query layers, error handling, auth middleware.
- **Security basics**: hashed passwords, bearer tokens, protected endpoints.
- **Data modeling**: concrete schema for users/characters, plus sample CRUD patterns.
- **Frontend integration**: client-side auth storage, guarded pages, API helpers.
- **Ops reality**: env-driven config, health/diagnostic endpoint, reverse proxy deployment.

Translation: you can skim it in an hour and know whether you’d trust me with your production pager. (I like sleeping too.)

## Tech stack

- **Runtime**: Node.js (>= 18)
- **Server**: Express, body-parser, morgan, cors
- **Auth**: bcryptjs, jsonwebtoken
- **Database**: MySQL
- **Client**: vanilla JS + a little jQuery, HTML, CSS
- **Tests**: Mocha + Chai (integration tests; opt-in)

## Repo tour (where things live)

- `index.js` — root entrypoint; loads the Express app.
- `Web-Server/` — Node/Express API + static hosting.
  - `src/index.js` — Express setup, static hosting, `/api/*` routing, `/api/_diag`.
  - `src/routes/*.routes.js` — API route definitions.
  - `src/controllers/*.controller.js` — request handlers.
  - `src/queries/*.queries.js` — SQL strings / query builders.
  - `src/db-config.js` — MySQL connection pool + bootstraps tables.
  - `src/middleware/*` — auth + error middleware.
  - `src/utils/*` — JWT helpers, DB query helper, HTTP error helpers.
  - `tests/*` — integration tests (skipped unless configured).
- `Application/public/` — static UI.
  - `index.html` — login/register.
  - `home.html` + feature pages (`abilities.html`, `physical-stats.html`, `pregen-characters*.html`).
  - `lib/` — front-end “services”: API config, auth, storage, fetch helpers.
  - `characters/` — character list UI logic + API service.
  - `pdf/` + `images/` — character assets.
- `Database/Dump20200419/` — MySQL dumps for local setup.

## Architecture (design + flow)

### Single-origin hosting

The same Express app serves:

- Static files (UI) from `Application/public/`
- REST API under `/api/*`

This removes CORS headaches in production: the browser calls `https://<host>/api/...` from pages already hosted on `https://<host>/...`.

### Request lifecycle (backend)

Typical flow for protected endpoints:

1. **Route** matches (e.g., `GET /api/tasks`).
2. **Auth middleware** validates `Authorization: Bearer <token>` and sets `req.user = { id, ... }`.
3. **Controller** performs validation + orchestration.
4. **Query helper** runs SQL against a MySQL pool.
5. **Response** returns JSON (or errors via middleware/handlers).

### Request lifecycle (frontend)

The UI uses a small set of helpers:

- `Application/public/lib/api.config.js` builds a same-origin `BASE_API_URL`.
- `Application/public/lib/service-helpers.js` wraps `fetch` and injects a fresh bearer token.
- `Application/public/lib/simple-storage.js` stores auth state in `localStorage` (base64-encoded JSON).
- `Application/public/lib/auth.guard.js` redirects users if they are not authenticated.

## Key features (with implementation details)

### 1) Auth (register/login/refresh/logout)

Endpoints:

- `POST /api/auth/register` — create user (bcrypt password hash)
- `POST /api/auth/login` — returns bearer token + refresh token
- `POST /api/auth/token` — exchanges refresh token for a new access token
- `POST /api/auth/logout` — invalidates refresh token (in-memory)

Notes:

- Passwords are hashed with bcrypt (`bcryptjs`).
- JWT secrets are configurable via env vars.
- Refresh tokens are stored in memory (`refreshTokens` array). That’s appropriate for a demo and a single-instance deploy; production multi-instance would persist/rotate tokens.

### 2) Users

- `GET /api/user/me` — returns current user profile
- `PUT /api/user/me/update` — updates username/email/password

### 3) Characters (pre-generated sheet library)

- `GET /api/characters` — list characters
- `GET /api/characters/:characterId` — fetch a character
- `POST /api/characters` — add a character
- `PUT /api/characters/:characterId` — update a character
- `DELETE /api/characters/:characterId` — delete a character

The UI renders a filtered, card-based list and links to PDFs/images stored under `Application/public/pdf/` and `Application/public/images/`.

### 4) Tasks (sample CRUD API)

- `GET /api/tasks`
- `POST /api/tasks`
- `GET /api/tasks/:taskId`
- `PUT /api/tasks/:taskId`
- `DELETE /api/tasks/:taskId`

These endpoints are protected and show a clean CRUD pattern with MySQL-backed persistence.

Important detail: `db-config.js` currently auto-creates `users` and `characters`. The `tasks` table definition exists in `Web-Server/src/queries/tasks.queries.js` but isn’t auto-created on boot.

## Database schema (high-level)

- `users`
  - `user_id` (PK)
  - `username` (unique)
  - `email`
  - `password` (bcrypt hash)
- `characters`
  - `character_id` (PK)
  - `character_name`, `character_race`, `character_class`, `character_build`
  - `character_level`
  - `character_sheet` (pdf filename), `character_image` (image filename)
  - `created_date`

## API diagnostics

- `GET /api/_diag`
  - Returns build/environment presence info (no secrets).
  - Also adds helpful `x-env-has-*` headers to responses.

This is designed for “is it wired correctly?” debugging when deploying behind a reverse proxy.

## Local development (Windows)

### Prereqs

- Node.js (>= 18)
- XAMPP (Apache + MySQL)

### Database setup

Option A: phpMyAdmin

1. Start **Apache** and **MySQL** in XAMPP.
2. Visit `http://localhost/phpmyadmin`.
3. Create a database named `ancientwhitearmyvet`.
4. Import:
   - `Database/Dump20200419/ancientwhitearmyvet_users.sql`
   - `Database/Dump20200419/ancientwhitearmyvet_characters.sql`

Option B: command line

1. Create DB:
   - `C:\xampp\mysql\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS ancientwhitearmyvet;"`
2. Import dumps:
   - `C:\xampp\mysql\bin\mysql.exe -u root ancientwhitearmyvet < Database\Dump20200419\ancientwhitearmyvet_users.sql`
   - `C:\xampp\mysql\bin\mysql.exe -u root ancientwhitearmyvet < Database\Dump20200419\ancientwhitearmyvet_characters.sql`

### Run the app

Recommended: VS Code tasks

- Run: **Terminal → Run Task** → `AWAV: Start XAMPP + Site + Open Browser`
- Browse: `http://ancientwhitearmyvet2020.localhost:4000`

Manual:

```bash
npm install
npm start
```

## Production deployment shape (reverse proxy)

Run Node on a private interface and let Apache/Nginx handle TLS + public ports.

Key idea:

- Reverse proxy `https://ancientwhitearmyvet.com/*` → `http://127.0.0.1:<PORT>/*`

Suggested env:

- `NODE_ENV=production`
- `PORT=4010` (any free port)
- `HOST=127.0.0.1` (prevents exposing the Node port publicly)

## Environment configuration

Common vars:

- `PORT` (default `4000`)
- `HOST` (optional bind host; use `127.0.0.1` in production behind a reverse proxy)
- `LOG_LEVEL` (morgan log level; default `dev`)
- `DB_HOST` (default local is `127.0.0.1`)
- `DB_PORT` (default `3306`)
- `DB_DATABASE` (default `ancientwhitearmyvet`)
- `DB_USER` (default `root`)
- `DB_PASS` (default blank for many XAMPP installs)
- `DB_CONN_LIMIT` (default `10`)

JWT secrets for production:

- `JWT_ACCESS_SECRET` (or `JWT_SECRET`)
- `JWT_REFRESH_SECRET`

## Testing

This repo includes opt-in integration tests.

- Configure:
  - `API_BASE_URL` (e.g., `http://localhost:4000`)
  - For tasks tests: `RUN_INTEGRATION=1` and `TEST_ACCESS_TOKEN="Bearer <token>"`
    - Note: the tasks test expects the user to already have at least one task row.
- Run:

```bash
npm test
```

## Quick “developer credibility” checklist

- Routes/controllers/queries are separated for readability.
- Auth middleware is explicit and reusable.
- Errors are handled with safe messages (no stack traces leaked to clients).
- Production deployment doesn’t require CORS duct tape.
- There’s a diagnostic endpoint for “why is prod broken?” moments.

## Credits / origin

Originally built as a final project for MSSE 661 (Web Software Development). The core idea came from a real Dungeon Master problem: reduce paper waste and streamline character distribution.
