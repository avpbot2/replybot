# Replybot

A Node.js, React, and MySQL workspace for customer messaging operations. The first implementation includes a Material UI dashboard, workspace registration/sign-in, tenant-scoped records, and starter screens for agents, inbox, knowledge, channels, flows, contacts, leads, bookings, orders, templates, campaigns, analytics, and settings.

## Run locally

Requirements: Node.js 20+, npm 10+, Docker Desktop (or a separately managed MySQL 8.0+ server).

1. Copy `.env.example` to `.env` and set a private `JWT_SECRET` with at least 32 characters. The example MySQL password is for local development only.
2. Start MySQL with `docker compose up -d mysql`. The schema is initialized the first time the database volume is created.
3. Install and start the web app and API:

   ```powershell
   npm install
   npm run dev
   ```

4. Open `http://localhost:5173` and create a workspace. The API runs at `http://localhost:4000`; `GET /api/health` checks the database connection.

If MySQL was already initialized before the schema was added or changed, apply `apps/api/schema.sql` to the `replybot` database with a MySQL 8 client. For a non-Docker MySQL server, create the database and user, then update the `MYSQL_*` variables in `.env`.

## Implemented API

- `POST /api/auth/register`, `POST /api/auth/login`
- `GET /api/health` (no login required)
- `GET /api/overview`
- Workspace-scoped `GET` and `POST /api/{agents,leads,bookings,campaigns,knowledge,channels,flows,templates,contacts,orders}`
- `GET /api/inbox/conversations`

Authenticated API calls use `Authorization: Bearer <token>`. The API validates user input and scopes records to the workspace in the signed token.

## Production integrations still required

This starter does not claim to provide live integrations. It does not yet send or receive messages through WhatsApp, Meta, Twilio, Telegram, Slack, Discord, email, IndiaMART, or TradeIndia. Webhook signature verification and event persistence have schema foundations only; webhook endpoints, background workers, retry queues, provider OAuth flows, and outbound delivery must be implemented per provider.

Knowledge records are stored as text, but document upload, URL crawling, embeddings, vector search, and RAG generation are not wired to an AI provider. Flows, campaigns, templates, bookings, and analytics currently provide basic record storage rather than executing production workflows. Before public deployment, add role-based authorization, rate limiting, secure secret storage, audit events, consent/opt-out enforcement, observability, backups, and integration-specific contract tests.

## Certificate troubleshooting

“Certificate is not yet valid” generally means a TLS certificate's `NotBefore` time is later than the clock used by the client. Check the computer/server clock and timezone first, then confirm the certificate chain and validity dates for the exact API/host being contacted. Do not disable TLS verification or use `NODE_TLS_REJECT_UNAUTHORIZED=0`; that hides the cause and makes connections vulnerable to interception.
