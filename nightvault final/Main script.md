#!/bin/bash
# NightVault-Lite v3.2 — Optimized Setup

# Step 1: Create base config
cat > ~/.vault.env << 'EOF'
MEGA_EMAIL="your-email@example.com"
MEGA_PASSWORD="your-password"
MEGA_PATH="/Root/nightvault"
NIGHTVAULT_HOME="${HOME}/nightvault"
RAMDISK_SIZE="1G"
SYNC_INTERVAL="60m"
COMPRESSION_LEVEL="6"
EOF
chmod 600 ~/.vault.env

# Step 2: Dir structure (unchanged)
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
IOSchedulingClass=best-effort
IOSchedulingPriority=7
MemoryMax=85%
MemoryHigh=75%
ExecStart=/bin/mount -t tmpfs -o size=1G,noatime,nosuid,nodev,noexec tmpfs /mnt/ramvault
ExecStart=/bin/bash -c 'rsync -az --partial --append-verify --delete --bwlimit=1000 --info=progress2 ~/nightvault/ram_backup/ /mnt/ramvault/'
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
Nice=19
IOSchedulingClass=idle
CPUQuota=50%
MemoryHigh=25%
EnvironmentFile=/home/%i/.vault.env
ExecStart=/bin/bash -c '
  mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD" --auth-code || exit 0
  rsync -az --partial --append-verify --delete --bwlimit=1000 --info=progress2 ~/nightvault/workspace/active/ ~/nightvault/data/
  mega-put ~/nightvault "$MEGA_PATH"
'

[Install]
WantedBy=multi-user.target
EOF
