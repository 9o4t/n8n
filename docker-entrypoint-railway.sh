#!/bin/sh
set -e
mkdir -p /home/node/.n8n
chown -R node:node /home/node/.n8n || true
# Drop to node if gosu/su-exec available; else run as root (Railway volumes need write)
if command -v gosu >/dev/null 2>&1; then
  exec gosu node n8n start
elif command -v su-exec >/dev/null 2>&1; then
  exec su-exec node n8n start
else
  exec n8n start
fi
