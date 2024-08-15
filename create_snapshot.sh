#!/bin/bash

# Get current date and time for snapshot name
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Function to create snapshot
create_snapshot() {
    local dataset=$1
    local snapshot_name="${dataset}@snapshot_${DATE}"
    
    echo "Creating snapshot: $snapshot_name"
    zfs snapshot "$snapshot_name"
}

# Get all datasets
datasets=$(zfs list -H -o name)

# Loop through datasets and create snapshots
for dataset in $datasets; do
    create_snapshot "$dataset"
done

echo "All snapshots created successfully!"
