#!/bin/bash

# Function to delete all but the newest snapshot for a dataset
delete_old_snapshots() {
    local dataset=$1
    local snapshots=$(zfs list -H -t snapshot -o name -s creation | grep "^${dataset}@" | head -n -1)
    
    if [ -n "$snapshots" ]; then
        echo "Deleting old snapshots for $dataset:"
        echo "$snapshots" | while read -r snapshot; do
            echo "  Deleting $snapshot"
            zfs destroy "$snapshot"
        done
    else
        echo "No old snapshots to delete for $dataset"
    fi
}

# Get all unique dataset names
datasets=$(zfs list -H -t snapshot -o name | cut -d'@' -f1 | sort -u)

# Iterate through each dataset
for dataset in $datasets; do
    delete_old_snapshots "$dataset"
done

echo "Snapshot cleanup completed."

