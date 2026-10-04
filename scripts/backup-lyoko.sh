#!/bin/sh
#
# Lyoko - pre-migration backup
#
# Run this on the OLD host before wiping it, as root (or with sudo):
#
#   sudo ./scripts/backup-lyoko.sh /mnt/usb/lyoko-backup
#   sudo sh ./scripts/backup-lyoko.sh /mnt/usb/lyoko-backup
#
# It stops the containers for a consistent copy, rsyncs /lyoko/apps (configs,
# databases, torrent stats, certificates) to the destination and starts the
# containers again unless KEEP_STOPPED=1 is set.
#
# Media and torrent files are NOT copied on purpose. Copy the ones you want to
# keep manually, e.g.:
#
#   rsync -aH --info=progress2 /lyoko/alexandria/media/movies/Some.Movie/ \
#     /mnt/usb/lyoko-backup/media/movies/Some.Movie/
#
# Notes:
# - Use a destination with a Linux filesystem (ext4/xfs/btrfs) so ownership
#   and permissions are preserved. exFAT/NTFS will lose them.
# - If you want to keep seeding, copy the matching files from
#   /lyoko/alexandria/torrents/ to the new host at the same paths and force a
#   recheck in qBittorrent.
#
set -eu

DEST="${1:-}"
LYOKO_ROOT="${LYOKO_DIR:-/lyoko}"

if [ -z "$DEST" ]; then
  echo "Usage: sudo $0 <destination-directory>" >&2
  echo "Example: sudo $0 /mnt/usb/lyoko-backup" >&2
  exit 1
fi

if [ ! -d "$LYOKO_ROOT" ]; then
  echo "Error: $LYOKO_ROOT not found - run this on the old Lyoko host." >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync is not installed (apt install rsync)." >&2
  exit 1
fi

mkdir -p "$DEST/apps"

STOPPED=""
restart_containers() {
  if [ "${KEEP_STOPPED:-0}" = "1" ] || [ -z "$STOPPED" ]; then
    echo "==> Containers left stopped."
    return
  fi
  echo "==> Starting containers again (set KEEP_STOPPED=1 to skip)..."
  # shellcheck disable=SC2086
  docker start $STOPPED >/dev/null
}
trap restart_containers EXIT

echo "==> Stopping containers for a consistent snapshot..."
STOPPED="$(docker ps -q)"
if [ -n "$STOPPED" ]; then
  # shellcheck disable=SC2086
  docker stop $STOPPED >/dev/null
else
  echo "    (no running containers)"
fi

echo "==> Backing up apps (configs, databases, torrent stats, certificates)..."
rsync -aH --numeric-ids --info=progress2 "$LYOKO_ROOT/apps/" "$DEST/apps/"

echo
echo "==> Skipping media + torrents (not part of this backup)."
if [ -d "$LYOKO_ROOT/alexandria" ]; then
  echo "    Size on disk: $(du -sh "$LYOKO_ROOT/alexandria" 2>/dev/null | cut -f1)"
  echo "    Copy what you keep manually, e.g.:"
  echo "      rsync -aH --info=progress2 \"$LYOKO_ROOT/alexandria/media/movies/Some.Movie/\" \"$DEST/media/movies/Some.Movie/\""
fi

echo
echo "==> Verification:"
check() {
  label="$1"
  path="$2"
  if [ -e "$DEST/$path" ]; then
    echo "  OK      $label"
  else
    echo "  MISSING $label  ($DEST/$path)" >&2
  fi
}

check "qBittorrent settings + stats " "apps/qbittorrent/config/qBittorrent/qBittorrent.conf"
RESUME_DIR="$(find "$DEST/apps/qbittorrent" -type d -name BT_backup 2>/dev/null | head -n 1)"
if [ -n "$RESUME_DIR" ]; then
  RESUME_COUNT="$(find "$RESUME_DIR" -name '*.fastresume' 2>/dev/null | wc -l | tr -d ' ')"
  echo "  OK      qBittorrent resume data    ($RESUME_COUNT fastresume files)"
else
  echo "  MISSING qBittorrent resume data    (no BT_backup directory under apps/qbittorrent)" >&2
fi
check "qui database               " "apps/qui"
check "Sonarr database            " "apps/sonarr/sonarr.db"
check "Radarr database            " "apps/radarr/radarr.db"
check "Prowlarr database          " "apps/prowlarr/prowlarr.db"
check "Jellyfin config + watch    " "apps/jellyfin/data"
check "Vaultwarden database       " "apps/vaultwarden/db.sqlite3"
check "Traefik certificates       " "apps/traefik/letsencrypt/acme.json"

echo
du -sh "$DEST" 2>/dev/null || true
echo "==> Done. Backup located at: $DEST"
