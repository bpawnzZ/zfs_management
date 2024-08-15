#!/bin/bash

# Set the snapshot suffix
SNAPSHOT_SUFFIX="@snapshot_2024-08-06_23-39-21"

# Get a list of all snapshots with the specified suffix
SNAPSHOTS=$(zfs list -H -t snapshot -o name | grep "${SNAPSHOT_SUFFIX}$")

# Check if we found any snapshots
if [ -z "$SNAPSHOTS" ]; then
    echo "No snapshots found with suffix ${SNAPSHOT_SUFFIX}"
    exit 1
fi

# Function to roll back a snapshot
rollback_snapshot() {
    local snapshot=$1
    local dataset=${snapshot%@*}

    echo "Rolling back $dataset to $snapshot"
    sudo zfs rollback -r "$snapshot"

    if [ $? -eq 0 ]; then
        echo "Successfully rolled back $dataset"
    else
        echo "Failed to roll back $dataset"
    fi
}

# Confirm with the user
echo "The following snapshots will be rolled back:"
echo "$SNAPSHOTS"
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled."
    exit 1
fi

# Iterate through the snapshots and roll them back
echo "$SNAPSHOTS" | while read -r snapshot; do
    rollback_snapshot "$snapshot"
done

echo "Rollback operation completed."

