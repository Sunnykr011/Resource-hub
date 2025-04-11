# NightVault-Lite v3: High-Performance Bug Bounty Operations System

> **System Overview**
> A high-performance bug bounty operations system featuring RAM disk for volatile operations, secure vault storage, and automated MEGA cloud backup with comprehensive safety features.

## 1. Installation Instructions

### Prerequisites
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y megacmd curl zip gpg rsync
```

### Core Components
1. **setup.sh**: System initialization script [[1]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)
2. **sync.sh**: Cloud synchronization script [[1]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)
3. **.vault.env**: Configuration file [[2]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=Using%20tmpfs%20RAM%20disk,speed%20up%20performance%20in)

### Directory Structure
```
~/nightvault/
├── tools/
│   ├── recon/
│   ├── exploit/
│   └── utils/
├── workspace/
│   ├── active/
│   └── archive/
├── data/
│   ├── payloads/
│   ├── notes/
│   └── config/
├── logs/
├── ram_backup/
└── ram -> /mnt/ramvault
```

## 2. Configuration Guide

### Basic Setup
1. Create configuration file:
```bash
cat > ~/.vault.env << EOF
MEGA_EMAIL="your-email@example.com"
MEGA_PASSWORD="your-password"
MEGA_PATH="/Root/nightvault"
NIGHTVAULT_HOME="${HOME}/nightvault"
EOF
chmod 600 ~/.vault.env
```

### RAM Disk Configuration [[1]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)
```bash
# /etc/fstab entry
tmpfs /mnt/ramvault tmpfs size=2G,mode=750,noatime 0 0
```

## 3. Usage Examples

### Basic Operations
```bash
# Start new engagement
cd ~/nightvault/ram/enum
mkdir target.com
cd target.com

# Run tools with RAM disk performance
subfinder -d target.com -o subdomains.txt
httpx -l subdomains.txt -o http_probe.txt
```

### Data Management
```bash
# Store persistent data
cp important_findings.txt ~/nightvault/workspace/active/target.com/

# Use RAM disk for temporary scans
nmap -T4 -p- target.com -oA /mnt/ramvault/scans/target_full_port
```

## 4. Security Recommendations

### File Permissions
```bash
# Secure vault directory
chmod 750 ~/nightvault
chmod 600 ~/.vault.env
chmod 700 ~/nightvault/data/payloads
```

### Cloud Security [[2]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=Using%20tmpfs%20RAM%20disk,speed%20up%20performance%20in)
- Use strong MEGA account password
- Enable 2FA on MEGA account
- Never share .vault.env file
- Regular audit of cloud contents

## 5. Performance Optimization

### RAM Disk Optimization [[1]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)
```bash
# Monitor RAM disk usage
df -h /mnt/ramvault

# Clear temporary files
rm -rf /mnt/ramvault/temp/*

# Drop caches if needed
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

### System Optimization
```bash
# Set temporary directory to RAM disk
export TMPDIR="/mnt/ramvault/temp"

# Parallel processing for tools
subfinder -d target.com -t 100
httpx -l hosts.txt -threads 50
```

## 6. Troubleshooting Guide

### Common Issues and Solutions

#### RAM Disk Issues
```bash
# Remount RAM disk
sudo umount /mnt/ramvault
sudo mount -t tmpfs -o size=2G,mode=750,noatime tmpfs /mnt/ramvault

# Restore from backup
rsync -az ~/nightvault/ram_backup/ /mnt/ramvault/
```

#### MEGA Sync Issues [[2]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=Using%20tmpfs%20RAM%20disk,speed%20up%20performance%20in)
```bash
# Check MEGA connection
mega-whoami

# Force relogin
mega-logout
mega-login $MEGA_EMAIL $MEGA_PASSWORD

# Verify cloud storage
mega-ls $MEGA_PATH
```

### Error Recovery
```bash
# Check logs
tail -f ~/nightvault/logs/sync.log
tail -f ~/nightvault/logs/setup.log

# Manual sync trigger
~/nightvault/sync.sh
```

## 7. Maintenance Tasks

### Regular Maintenance
```bash
# Clean old RAM disk data
find /mnt/ramvault/temp -type f -mtime +1 -delete

# Verify backups
mega-ls "${MEGA_PATH}/ram_backup"

# Check disk usage
du -sh ~/nightvault/*
```

### System Updates
```bash
# Update MEGAcmd
sudo apt update && sudo apt upgrade megacmd

# Verify system status
systemctl status nightvault-sync.service
```

> **Best Practices**
> - Regularly review logs for errors
> - Keep tools updated
> - Clean temporary files periodically
> - Verify cloud backups weekly
> - Test restore process monthly

This comprehensive setup provides a robust, secure, and high-performance environment for bug bounty operations while ensuring data persistence through automated cloud backups [[1]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)[[2]](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=Using%20tmpfs%20RAM%20disk,speed%20up%20performance%20in).


### References

1. **Using tmpfs RAM disk and noatime option to speed up ...**. [https://steemit.com](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=%23%20the%20tmpfs%20RAM)
2. **Using tmpfs RAM disk and noatime option to speed up ...**. [https://steemit.com](https://steemit.com/linux/@hairetikos/using-tmpfs-ram-disk-and-noatime-option-to-speed-up-performance-in-gnu-linux#:~:text=Using%20tmpfs%20RAM%20disk,speed%20up%20performance%20in)
