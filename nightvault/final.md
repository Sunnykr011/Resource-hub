#!/bin/bash

### NightVault-Lite v3.3 (Glitch Mode Edition)
# Ultra-stable + bug-fixed + ramdisk optimized + snapshot + recovery + MEGA cloud sync
# By: @SunnyMode (Vibe Mode + Glitch Mode Fusion)

# Load environment
source ~/.vault.env

# Ensure ~/.nightvault exists
mkdir -p ~/.nightvault

# Mount RAM disk
sudo mount -t tmpfs -o size=1G tmpfs /mnt/ramvault

# Link RAM dir
rm -f ~/nightvault/ram
ln -sfn /mnt/ramvault ~/nightvault/ram

# Kill MEGA cmd if already running incorrectly
pkill -f megacmd 2>/dev/null

# Login to MEGA (without --auth-code)
if [[ -n "$MEGA_SESSION" ]]; then
  mega-login "$MEGA_SESSION"
else
  mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD"
fi

# Snapshot logic
snapshot() {
  SNAP_TIME=$(date +%Y-%m-%d_%H-%M-%S)
  SNAP_DIR=~/nightvault/.state/snapshot-$SNAP_TIME
  mkdir -p "$SNAP_DIR"
  rsync -a --delete ~/nightvault/ "$SNAP_DIR/"
  echo "Snapshot saved to $SNAP_DIR"
}

# Recovery logic
recover() {
  LATEST=$(ls -td ~/nightvault/.state/snapshot-* | head -n 1)
  if [[ -d "$LATEST" ]]; then
    rsync -a --delete "$LATEST/" ~/nightvault/
    echo "Recovered snapshot from $LATEST"
  else
    echo "No snapshots found."
  fi
}

# SHA checksum generation
find ~/nightvault -type f -exec sha256sum {} + > ~/.nightvault/checksums.sha256

# Daemonized sync timer setup (optional)
mkdir -p ~/.config/systemd/user/
cat > ~/.config/systemd/user/nightvault-sync.timer <<EOF
[Unit]
Description=NightVault Sync Timer

[Timer]
OnBootSec=30s
OnUnitActiveSec=15min
Persistent=true

[Install]
WantedBy=default.target
EOF

cat > ~/.config/systemd/user/nightvault-sync.service <<EOF
[Unit]
Description=NightVault Sync Service

[Service]
ExecStart=${HOME}/nightvault/bin/snapshot.sh
Type=oneshot
EOF

systemctl --user daemon-reexec
systemctl --user enable --now nightvault-sync.timer

# Run monitor in background (optional)
nohup ~/nightvault/bin/monitor.sh & disown

# Done!
echo "[+] NightVault-Lite v3.3 is armed in Glitch Mode ⚡"
echo "Use snapshot or recover functions manually or let systemd handle it."

# Export alias if needed
echo 'alias vaultsnap="bash ~/nightvault/bin/snapshot.sh"' >> ~/.bashrc
