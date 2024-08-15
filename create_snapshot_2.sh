#!/bin/bash

# Function to create snapshots for a given pool
create_snapshots() {
    local pool=$1
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)

    echo "Creating snapshots for $pool..."
    
    # List all datasets in the pool
    datasets=$(zfs list -H -o name -r $pool)

    for dataset in $datasets; do
        echo "Creating snapshot for $dataset"
        zfs snapshot ${dataset}@snapshot_${timestamp}
    done
}

# Create snapshots for bpool
create_snapshots zroot

# Create snapshots for rpool
#create_snapshots rpool

echo "Snapshot creaion complete."

