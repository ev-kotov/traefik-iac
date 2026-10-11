#!/usr/bin/env bash
set -e

log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [$1] $2"
}

I="INFO"
W="WARNING"
E="ERROR"
S="SUCCESS"

log "$I" "Checking environment."
log "$I" "User: $USER."
log "$I" "Home directory: $HOME."

QUADLET_DIR="$HOME/.config/containers/systemd"
USER_UNIT_DIR="$HOME/.config/systemd/user"
PROJECT_DIR="$HOME/projects/traefik-iac"

if [ ! -S "/run/user/$UID/podman/podman.sock" ]; then
    log "$W" "Podman socket not found. Run: systemctl --user enable --now podman.socket"
fi

if ! podman network ls --format '{{.Name}}' | grep -q "^traefik-public$"; then
    log "$E" "Сеть 'traefik-public' не найдена."
    log "$E" "First deploy init-iac: cd ~/projects/init-iac && sh deploy.sh"
    exit 1
fi

log "$I" "Preparing directories and files."
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$QUADLET_DIR"

if [ ! -f "$PROJECT_DIR/acme.json" ]; then
    touch "$PROJECT_DIR/acme.json"
    log "$S" "Created acme.json."
fi

log "$I" "Correct rights."
chmod 600 "$PROJECT_DIR/acme.json"

log "$I" "Check yml config."
if [ ! -f "$PROJECT_DIR/traefik.yml" ]; then
    log "$E" "Not found  traefik.yml in $PROJECT_DIR"
    exit 1
fi

log "$I" "Containers. Creating Quadlet network symlinks."
ln -sf "$PROJECT_DIR/traefik.container" "$QUADLET_DIR/"

log "$I" "Reloading systemd configuration"
systemctl --user daemon-reload

log "$I" "Restart service"
systemctl --user restart traefik.service

log "$I" "Check status... Please, waiting."
sleep 3
systemctl --user status traefik.service --no-pager
podman ps --filter name=traefik

log "$S" "Service deployed."

log "$I" "Dashboard: http://localhost:8081/dashboard/"
log "$I" "Check: curl http://localhost:8081/api/version"