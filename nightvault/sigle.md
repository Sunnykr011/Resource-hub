#!/bin/bash
# NightVault-Lite v3.1 — Full Setup with Snapshot/Recovery System

# Step 1: Create base config
cat > ~/.vault.env << 'EOF'
MEGA_EMAIL="your-email@example.com"
MEGA_PASSWORD="your-password"
MEGA_PATH="/Root/nightvault"
NIGHTVAULT_HOME="${HOME}/nightvault"
RAMDISK_SIZE="2G"
SYNC_INTERVAL="30m"
EOF
chmod 600 ~/.vault.env

# Step 2: Dir structure
mkdir -p ~/nightvault/{tools/{recon,exploit},workspace/{active,archive},data/{payloads,config},logs,ram_backup,.state}
ln -sfn /mnt/ramvault ~/nightvault/ram

# Step 3: RAM disk systemd
sudo tee /etc/systemd/system/nightvault-ramdisk.service > /dev/null << 'EOF'
[Unit]
Description=NightVault RAM Disk Mount
DefaultDependencies=no
Before=local-fs.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/mount -t tmpfs -o size=2G,noatime tmpfs /mnt/ramvault
ExecStart=/bin/bash -c 'rsync -a --delete ~/nightvault/ram_backup/ /mnt/ramvault/'
ExecStop=/bin/umount /mnt/ramvault
[Install]
WantedBy=local-fs.target
EOF

# Step 4: Cloud Sync systemd
sudo tee /etc/systemd/system/nightvault-sync.service > /dev/null << 'EOF'
[Unit]
Description=NightVault Cloud Sync Service
After=network-online.target
[Service]
Type=oneshot
EnvironmentFile=/home/%i/.vault.env
ExecStart=/bin/bash -c '
  mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD" --auth-code || exit 0
  rsync -a --ignore-existing ~/nightvault/workspace/active/ ~/nightvault/data/
  mega-put ~/nightvault "$MEGA_PATH"
'
[Install]
WantedBy=multi-user.target
EOF

# Step 5: Periodic sync timer
sudo tee /etc/systemd/system/nightvault-sync.timer > /dev/null << 'EOF'
[Unit]
Description=NightVault Periodic Sync
[Timer]
OnBootSec=5min
OnUnitActiveSec=30min
[Install]
WantedBy=timers.target
EOF

# Step 6: Health monitor
mkdir -p ~/nightvault/bin
cat > ~/nightvault/bin/monitor.sh << 'EOF'
#!/bin/bash
source ~/.vault.env
while true; do
    issues=0
    [[ ! -d /mnt/ramvault ]] && systemctl restart nightvault-ramdisk.service && ((issues++))
    ! pgrep mega-cmd > /dev/null && systemctl restart nightvault-sync.service && ((issues++))
    [[ $issues -gt 0 ]] && echo "[!] Health issue at $(date)" >> ~/nightvault/logs/health.log
    sleep 300
done
EOF
chmod +x ~/nightvault/bin/monitor.sh

# Step 7: Snapshot script
cat > ~/nightvault/bin/snapshot.sh << 'EOF'
#!/bin/bash
source ~/.vault.env
STAMP=$(date +"%Y-%m-%d_%H-%M")
TARGET=~/nightvault/.state/snapshot-$STAMP
mkdir -p "$TARGET"
rsync -a --delete ~/nightvault/ "$TARGET" --exclude=.state
mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD" --auth-code
mega-put "$TARGET" "$MEGA_PATH/snapshots/"
echo "[\u2713] Snapshot saved at $STAMP"
EOF
chmod +x ~/nightvault/bin/snapshot.sh

# Step 8: Recovery script
cat > ~/nightvault/bin/recover.sh << 'EOF'
#!/bin/bash
source ~/.vault.env
mountpoint -q /mnt/ramvault || (mount -t tmpfs -o size=$RAMDISK_SIZE,noatime tmpfs /mnt/ramvault && rsync -a ~/nightvault/ram_backup/ /mnt/ramvault/)
mega-whoami &>/dev/null || mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD" --auth-code
[[ ! -d ~/nightvault/data/payloads ]] && {
  mkdir -p ~/nightvault_temp && mega-get "$MEGA_PATH" ~/nightvault_temp
  rsync -a --ignore-existing ~/nightvault_temp/ ~/nightvault/
  rm -rf ~/nightvault_temp
}
echo "[\u2713] Recovery complete"
EOF
chmod +x ~/nightvault/bin/recover.sh

# Step 9: Auto-start + timer
sudo systemctl daemon-reload
sudo systemctl enable --now nightvault-ramdisk.service
sudo systemctl enable --now nightvault-sync.timer

# Step 10: Final touch
echo "[\u2713] NightVault v3.1 deployed!"
echo "[+] Run: ~/nightvault/bin/snapshot.sh  # to save state"
echo "[+] Run: ~/nightvault/bin/recover.sh   # to restore from cloud"
