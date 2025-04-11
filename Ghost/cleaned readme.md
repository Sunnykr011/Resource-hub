# 🌑 NightVault - Getting Started Guide

> A step-by-step guide to setting up your secure, RAM-enhanced hacking environment

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Cloud Setup](#cloud-setup)
3. [Initial Installation](#initial-installation)
4. [RAM Disk Configuration](#ram-disk-configuration)
5. [Daily Usage](#daily-usage)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have:
- Linux system with minimum 4GB RAM
- Root/sudo access
- Internet connection
- Basic command line knowledge

Required packages:
```bash
sudo apt update && sudo apt install -y \
    rclone \
    gpg \
    curl \
    rsync \
    megacmd
```

## Cloud Setup

### 1. Create MEGA Account
1. Visit [MEGA.nz](https://mega.nz) and sign up
2. Note down your credentials:
   ```
   Email: your@email.com
   Password: your-secure-password
   ```

### 2. Configure MEGA CLI
```bash
# Install MEGA CLI
mega-login your@email.com your-password

# Verify connection
mega-whoami
```

## Initial Installation

### 1. Download NightVault
```bash
# Get the installation script
curl -O https://raw.githubusercontent.com/yourusername/nightvault/main/nightvault.sh
chmod +x nightvault.sh
```

### 2. Basic Configuration
```bash
# Set up environment variables
export NIGHTVAULT_HOME="${HOME}/.nightvault"
export NIGHTVAULT_VERSION="1.0.0"

# Run initial setup
./nightvault.sh
```

## RAM Disk Configuration

### 1. Set Up RAM Disk
```bash
# Download RAM disk manager
curl -O https://raw.githubusercontent.com/yourusername/nightvault/main/ramdisk_manager.sh
chmod +x ramdisk_manager.sh

# Configure RAM disk size (for 4GB systems)
echo "RAMDISK_SIZE=921M" > ~/.nightvault.conf
```

### 2. Mount Points
```bash
# Create mount points
sudo mkdir -p /mnt/ramdisk
sudo chown $USER:$USER /mnt/ramdisk

# Add to /etc/fstab
echo "tmpfs /mnt/ramdisk tmpfs defaults,size=921M,mode=0750 0 0" | sudo tee -a /etc/fstab
```

## Daily Usage

### 1. Starting the System
```bash
# Start RAM disk manager
./ramdisk_manager.sh &

# Start NightVault
./nightvault.sh
```

### 2. Common Operations
```bash
# Check RAM disk usage
df -h /mnt/ramdisk

# Sync with cloud
nightvault sync

# Access your tools
cd ~/tools  # Points to RAM disk
```

### 3. Security Operations
```bash
# Encrypt sensitive file
encrypt_sensitive secret.txt

# Verify file integrity
verify_integrity
```

## Troubleshooting

### Common Issues and Solutions

1. **RAM Disk Full**
```bash
# Clean temporary files
cleanup_old_files

# Increase RAM disk size (if possible)
edit ~/.nightvault.conf
```

2. **Sync Issues**
```bash
# Force sync
nightvault sync --force

# Check logs
tail -f ${NIGHTVAULT_HOME}/security/logs/sync.log
```

3. **Permission Issues**
```bash
# Reset permissions
chmod -R 750 ${NIGHTVAULT_HOME}
chmod -R 750 /mnt/ramdisk
```

## Quick Reference

### Important Directories
- `/mnt/ramdisk/active-tools` - Frequently used tools
- `~/.nightvault/cloud` - Cloud storage sync
- `~/.nightvault/security/logs` - System logs

### Common Commands
```bash
nightvault status        # Check system status
nightvault sync         # Sync with cloud
nightvault monitor      # Monitor RAM usage
nightvault encrypt      # Encrypt sensitive data
```

### Default Configurations
- RAM Disk Size: 921MB
- Sync Interval: 5 minutes
- Security Level: Military-grade (GPG/ed25519)

> **Note**: Always ensure your data is synced before shutting down the system, as RAM disk contents are temporary.

This README provides a clear, step-by-step approach to setting up and using the NightVault system. Each section is organized logically, making it easier to follow and implement the system components.

