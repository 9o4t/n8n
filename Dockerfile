FROM docker.n8n.io/n8nio/n8n:latest
USER root
COPY docker-entrypoint-railway.sh /docker-entrypoint-railway.sh
RUN chmod +x /docker-entrypoint-railway.sh
ENTRYPOINT ["/docker-entrypoint-railway.sh"]
