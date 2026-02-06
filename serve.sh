#!/bin/bash
# Quick HTTP server for cowboycuban via Traefik
# Uses path-based routing on existing Tailscale hostname
# Access at: https://tailscale-coder.curl-mahi.ts.net/cowboycuban/

CONTAINER_NAME="cowboycuban-http"
HOSTNAME="tailscale-coder.curl-mahi.ts.net"
PATH_PREFIX="/cowboycuban"

# Stop existing container if running
if sudo docker ps -q -f name="^${CONTAINER_NAME}$" | grep -q .; then
    echo "Stopping existing container..."
    sudo docker rm -f "$CONTAINER_NAME" > /dev/null
fi

echo "Starting HTTP server for cowboycuban"

sudo docker run -d \
  --name "$CONTAINER_NAME" \
  --network code-server_default \
  -v claude_projects:/home/claude:ro \
  -l "traefik.enable=true" \
  -l "traefik.http.routers.cowboycuban.rule=Host(\`${HOSTNAME}\`) && PathPrefix(\`${PATH_PREFIX}\`)" \
  -l "traefik.http.routers.cowboycuban.entrypoints=websecure" \
  -l "traefik.http.routers.cowboycuban.tls=true" \
  -l "traefik.http.routers.cowboycuban.tls.certresolver=myresolver" \
  -l "traefik.http.routers.cowboycuban.middlewares=cowboycuban-slash,cowboycuban-strip" \
  -l "traefik.http.middlewares.cowboycuban-slash.redirectregex.regex=^(https?://[^/]+${PATH_PREFIX})$$" \
  -l "traefik.http.middlewares.cowboycuban-slash.redirectregex.replacement=\$\${1}/" \
  -l "traefik.http.middlewares.cowboycuban-slash.redirectregex.permanent=true" \
  -l "traefik.http.middlewares.cowboycuban-strip.stripprefix.prefixes=${PATH_PREFIX}" \
  -l "traefik.http.services.cowboycuban.loadbalancer.server.port=8000" \
  python:3-alpine \
  python -m http.server 8000 --bind 0.0.0.0 --directory /home/claude/cowboycuban

echo "Container started. Access at: https://${HOSTNAME}${PATH_PREFIX}/"
echo "Stop with: sudo docker rm -f $CONTAINER_NAME"
