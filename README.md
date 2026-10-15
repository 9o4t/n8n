# Deploy and Host n8n on Railway

Self-host [n8n](https://n8n.io/) with Railway Postgres. Official `n8nio/n8n` image. This is the Zapier-shaped stack on [c17.io/stacks/n8n-automation](https://c17.io/stacks/n8n-automation). Activepieces is a **separate** template: [9o4t/activepieces](https://github.com/9o4t/activepieces).

No LLM or SaaS API keys are required to boot. Railway injects `PORT`. The template generates `N8N_ENCRYPTION_KEY` and wires `WEBHOOK_URL` to the public domain.

## About Hosting n8n

n8n is fair-code workflow automation: HTTP, webhooks, spreadsheets, Slack, and a large node library. Credentials live in Postgres, encrypted with `N8N_ENCRYPTION_KEY`. Binary data and the settings file live on a volume at `/home/node/.n8n`.

On Railway this is two services:

| Service | Source | Public | Notes |
|---|---|---|---|
| `n8n` | Docker image `n8nio/n8n` | Yes | Health `GET /healthz`. Volume `/home/node/.n8n`. |
| `Postgres` | Railway plugin | No | Workflows, credentials, execution history. |

The first account you create in the editor is the owner. There is no default username or password.

## Common Use Cases

- Replace a Zapier or Make graph: form → PocketBase → Resend / Slack
- Webhook ingress for agents and SaaS events
- Scheduled jobs you can version and fork
- Air-gapped or customer-data workflows you will not put on a metered SaaS

## Dependencies for n8n Hosting

### Required (wired or generated — you do not type these)

| Variable | Service | Source |
|---|---|---|
| `PORT` | n8n | Injected. Also set `N8N_PORT=${{PORT}}`. |
| `N8N_PROTOCOL` | n8n | `https` |
| `N8N_HOST` | n8n | `${{RAILWAY_PUBLIC_DOMAIN}}` |
| `WEBHOOK_URL` | n8n | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |
| `N8N_ENCRYPTION_KEY` | n8n | Generated 32-byte hex. Back this up. Losing it makes stored credentials unreadable. |
| `DB_TYPE` | n8n | `postgresdb` |
| `DB_POSTGRESDB_HOST` | n8n | `${{Postgres.PGHOST}}` |
| `DB_POSTGRESDB_PORT` | n8n | `${{Postgres.PGPORT}}` |
| `DB_POSTGRESDB_DATABASE` | n8n | `${{Postgres.PGDATABASE}}` |
| `DB_POSTGRESDB_USER` | n8n | `${{Postgres.PGUSER}}` |
| `DB_POSTGRESDB_PASSWORD` | n8n | `${{Postgres.PGPASSWORD}}` |

### Optional

| Variable | Required | Why |
|---|---|---|
| `GENERIC_TIMEZONE` | No | Cron timezone, e.g. `America/New_York`. Default UTC. |
| `N8N_EDITOR_BASE_URL` | No | Override editor URL if you add a custom domain later. |
| Slack / OpenAI / Google keys | No | Added inside n8n credentials after deploy. BYO. Not template variables. |

n8n used to ship `N8N_BASIC_AUTH_*`. Current images use the built-in owner account instead. Do not rely on basic-auth env vars.

### Volume

| Mount | Service | Why |
|---|---|---|
| `/home/node/.n8n` | n8n | Settings, binary data, local files. Keep it even with Postgres. |

## Why Deploy n8n on Railway?

Zapier Professional meters tasks. A small sales-ops shop hits four figures a year before the graph is interesting. n8n on a Railway service plus Postgres is usually a few dollars a month; you pay the APIs you call, not a per-zap tax. Trial credits cover the first deploy for most people. c17 never charges you — Railway usage is the referral / template kickback.

See `TEMPLATE.md` for the marketplace / composer shape.

## Run locally

```bash
cp .env.example .env
# set POSTGRES_PASSWORD and N8N_ENCRYPTION_KEY (openssl rand -hex 32)
docker compose up
```

Editor: http://localhost:5678 — create the first owner account.

## License

n8n is fair-code (Sustainable Use License). This repo is config and docs only.
