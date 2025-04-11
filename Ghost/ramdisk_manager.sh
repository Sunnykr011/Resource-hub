#!/bin/bash

# RAM Disk Manager for NightVault
# Automatically manages RAM disk allocation and synchronization

# Configuration
RAMDISK_SIZE="921M"
RAMDISK_MOUNT="/mnt/ramdisk"
SYNC_INTERVAL=300  # 5 minutes

# Create and mount RAM disk
setup_ramdisk() {
    echo "Setting up RAM disk..."
    mkdir -p ${RAMDISK_MOUNT}
    mount -t tmpfs -o size=${RAMDISK_SIZE},mode=0750 tmpfs ${RAMDISK_MOUNT}
    
    # Create required directories
    mkdir -p ${RAMDISK_MOUNT}/{active-tools,temp-builds,cache}
    chmod 750 ${RAMDISK_MOUNT}/*
}

# Monitor RAM disk usage
monitor_usage() {
    local usage=$(df -h ${RAMDISK_MOUNT} | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ $usage -gt 90 ]; then
        echo "WARNING: RAM disk usage above 90%"
        cleanup_old_files
    fi
}

# Sync with cloud storage
sync_with_cloud() {
    rsync -avz --delete ${RAMDISK_MOUNT}/ ${NIGHTVAULT_HOME}/cloud/
    rclone sync ${NIGHTVAULT_HOME}/cloud remote:nightvault
}

# Main loop
main() {
    setup_ramdisk
    
    while true; do
        monitor_usage
        sync_with_cloud
        sleep ${SYNC_INTERVAL}
    done
}

main "$@"
