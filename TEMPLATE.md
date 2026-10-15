# Railway template config (n8n + Postgres)

Publish from Dave's Railway account using the official `n8nio/n8n` image plus Railway Postgres. Then put the published template code in `9o4t/c17` `internal/railway/templates.go` as `"n8n-automation": "<code>"`. Do not invent a code.

Public source / docs: GitHub [`9o4t/n8n`](https://github.com/9o4t/n8n). The running service is the Docker image, not a build of this repo.

Activepieces is a **separate** template (`9o4t/activepieces`). Do not combine them.

## Services

| Field | n8n | Postgres |
|---|---|---|
| Name | `n8n` | `Postgres` |
| Source | Docker image `n8nio/n8n` | Railway plugin |
| Public | Yes, one domain | No |
| Healthcheck | `GET /healthz` | plugin default |
| Healthcheck timeout | 60s | — |
| Restart | on failure | plugin default |
| Volume | `/home/node/.n8n` | plugin volume |

## Variables Railway provides

| Variable | Service | Value |
|---|---|---|
| `PORT` | n8n | Injected |
| `N8N_PORT` | n8n | `${{PORT}}` |
| `N8N_PROTOCOL` | n8n | `https` |
| `N8N_HOST` | n8n | `${{RAILWAY_PUBLIC_DOMAIN}}` |
| `WEBHOOK_URL` | n8n | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |
| `N8N_LISTEN_ADDRESS` | n8n | `0.0.0.0` |
| `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS` | n8n | `true` |
| `N8N_ENCRYPTION_KEY` | n8n | Generated secret (32 hex chars). Do not prompt the operator. |
| `DB_TYPE` | n8n | `postgresdb` |
| `DB_POSTGRESDB_HOST` | n8n | `${{Postgres.PGHOST}}` |
| `DB_POSTGRESDB_PORT` | n8n | `${{Postgres.PGPORT}}` |
| `DB_POSTGRESDB_DATABASE` | n8n | `${{Postgres.PGDATABASE}}` |
| `DB_POSTGRESDB_USER` | n8n | `${{Postgres.PGUSER}}` |
| `DB_POSTGRESDB_PASSWORD` | n8n | `${{Postgres.PGPASSWORD}}` |

## Variables the operator may provide

None are required to boot.

| Variable | Required | Why |
|---|---|---|
| `GENERIC_TIMEZONE` | No | Cron timezone. Default UTC. |

Do not collect Slack, OpenAI, or other SaaS keys in the template. Those are n8n credentials after deploy.

## Composer / dashboard publish checklist

1. Sign in as Dave on [railway.com](https://railway.com).
2. New project. Add Docker image `n8nio/n8n`. Add Railway Postgres.
3. Attach volume `/home/node/.n8n` on `n8n`.
4. Set the variables in the table. Generate `N8N_ENCRYPTION_KEY`. Wire Postgres refs. Generate a public domain, then confirm `WEBHOOK_URL` and `N8N_HOST` match it (`https://${{RAILWAY_PUBLIC_DOMAIN}}`).
5. Healthcheck `GET /healthz`. Timeout 60s. Restart on failure.
6. Confirm the editor boots with **zero required operator env vars**. Create the first owner in the UI.
7. Generate a template from that project: dashboard **Generate Template**, or `railway templates create --project <id> --json`.
8. In the template editor: two services, image + Postgres, volume, generated encryption key, no operator API keys.
9. Description (≤75 chars): `n8n + Postgres. Volume, healthcheck, webhook URL. No API keys.`
10. Publish, category **Automation** (or **Starters**):

    ```
    railway templates publish <template-id> --category Automation \
      --description "n8n + Postgres. Volume, healthcheck, webhook URL. No API keys." \
      --readme-file README.md --json
    ```

11. Copy the published **template code** (the path segment in `https://railway.com/new/template/<code>`).
12. In `9o4t/c17`, set `internal/railway/templates.go`:

    `"n8n-automation": "<code>"`

    That entry switches `/stacks/n8n-automation`, process **Automation**, newsletter `000-coming-next`, and `/replace/{zapier,make}` from **Start on Railway** to the official Deploy button with `referralCode=4xHDyE`.
13. Run `go test ./...` in c17. Merge only when the code is the real published one.
