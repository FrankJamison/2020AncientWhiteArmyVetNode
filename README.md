# AncientWhiteArmyVet RPG Tools

An old-school web app with a modern goal: **make game-night logistics boring**.
This project serves pre-generated D&D character sheets, includes auth + role-aware UI, and exposes a small REST API backed by MySQL.

If you're an employer/recruiter: this repo demonstrates full-stack fundamentals (HTTP, auth, database integration, static hosting, and pragmatic tooling) without hiding behind frameworks.

## Highlights

- **Single-origin deployment**: one Express server hosts both the static front-end and `/api` routes.
- **JWT auth**: register/login flows, protected endpoints, client-side guarded routes.
- **MySQL-backed data**: users + characters, with automatic table creation on boot.
- **Static UI + AJAX**: HTML/CSS/JS front-end that calls the REST API.
- **Developer experience**: VS Code tasks to start everything and open a friendly local domain.

## Tech Stack

- **Runtime**: Node.js
- **Server**: Express, body-parser, morgan, cors
- **Auth**: bcryptjs (password hashing), jsonwebtoken (JWT)
- **Database**: MySQL (works great with XAMPP locally)
- **Client**: vanilla JS + jQuery, HTML, CSS

## Architecture (what lives where)

- `Web-Server/` — Primary Node/Express app for local + single-origin hosting.
  - Serves the front-end from `Application/public/`
  - Exposes the REST API under `/api/*`
- `Application/public/` — Static front-end pages, scripts, and assets.
  - Uses a same-origin API base (so production can be `https://<host>/api`)
- `Database/Dump20200419/` — MySQL SQL dumps for local setup.

## Key Features (design + development)

### 1) Authentication & authorization

- Passwords are hashed (bcrypt)
- JWT access/refresh token approach
- Middleware-driven route protection
- UI behavior changes based on auth state

### 2) Data model & persistence

- Two core entities: **users** and **characters**
- Data access is layered: routes → controllers → query helpers
- Server boot creates required tables if missing (useful for local dev)

### 3) UI/UX & interaction model

- Multi-page UI with reusable CSS modules
- AJAX-driven selector flows (class/subclass/level narrowing)
- Character downloads link to stored PDFs and images

### 4) Operational concerns

- Configurable via environment variables
- CORS enabled for API usage
- Diagnostics endpoint to verify environment wiring

## Local Development (Windows)

### Prereqs

- Node.js (>= 18)
- XAMPP (Apache + MySQL)

### 1) Set up the database

Option A: phpMyAdmin

1. Start **Apache** and **MySQL** in XAMPP.
2. Go to `http://localhost/phpmyadmin`.
3. Create a database named `ancientwhitearmyvet`.
4. Import from `Database/Dump20200419`:
   - `ancientwhitearmyvet_users.sql`
   - `ancientwhitearmyvet_characters.sql`

Option B: command line

1. Create DB:
   - `C:\xampp\mysql\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS ancientwhitearmyvet;"`
2. Import dumps:
   - `C:\xampp\mysql\bin\mysql.exe -u root ancientwhitearmyvet < Database\Dump20200419\ancientwhitearmyvet_users.sql`
   - `C:\xampp\mysql\bin\mysql.exe -u root ancientwhitearmyvet < Database\Dump20200419\ancientwhitearmyvet_characters.sql`

### 2) Start everything (recommended)

This repo includes VS Code tasks that:

- start XAMPP
- run `npm install`
- free port `4000` if needed
- start the Node server
- open the browser

Run: **Terminal → Run Task** → `AWAV: Start XAMPP + Site + Open Browser`

Then browse:

- `http://ancientwhitearmyvet2020.localhost:4000`

### 3) Start manually (without tasks)

From the repo root:

```bash
npm install
npm start
```

Default URL:

- `http://localhost:4000`

## API Notes

- Base: `/api`
- Quick sanity check:
  - `GET /api/_diag` (returns build/env presence info; no secrets)

## Environment configuration

The API supports environment variables (especially for production). Template:

- `Web-Server/.env.example`

Common vars:

- `PORT` (default `4000`)
- `DB_HOST` (default local is `127.0.0.1`)
- `DB_PORT` (default `3306`)
- `DB_DATABASE` (default `ancientwhitearmyvet`)
- `DB_USER` (default `root`)
- `DB_PASS` (default blank for many XAMPP installs)

JWT secrets for production:

- `JWT_ACCESS_SECRET`
- `JWT_REFRESH_SECRET`

## Testing

Browser flows to validate quickly:

1. Register a user
2. Login
3. Generate ability scores and physical characteristics
4. Browse pre-generated characters and download a PDF
5. (Authenticated) Add/Delete characters

Key pages:

- Home: `/`
- Pre-gens: `/pregen-characters.html`
- Add/Delete: `/pregen-characters-add.html`

Note: Sample data is primarily for level 9 characters.

## Why this project is “portfolio useful”

- Shows end-to-end ownership: UI → API → database → deployment shape
- Demonstrates pragmatic, readable code organization
- Exercises common real-world requirements: auth, CRUD, files/assets, and environment-driven config

## Credits / origin

Originally built as a final project for MSSE 661 (Web Software Development). The core idea came from a real Dungeon Master problem: reduce paper waste and streamline character distribution.
