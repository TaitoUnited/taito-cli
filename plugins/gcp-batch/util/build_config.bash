#!/bin/bash


# Parse volumes from the variable
task_volumes=()
container_volumes=()

while read -r line; do
  if [[ -z "$line" ]]; then
    continue
  fi
  
# Split at the last colon to handle gs:// correctly
  gcs_path=${line%:*}
  container_path=${line##*:}
  
  # Remove gs:// prefix and bucket name to get just the path
  bucket=$(echo "$gcs_path" | sed -E 's|gs://([^/]+)/.*|\1|')
  remote_path=$(echo "$gcs_path" | sed -E 's|gs://[^/]+/(.*)|\1|')
  
  # Define local mount path
  local_mount="/mnt/disks/share/${remote_path##*/}"
  
  # Add to task volumes array
  task_volumes+=("$(jq -n \
    --arg remote_path "$remote_path" \
    --arg mount_path "$local_mount" \
    '{
      "gcs": {
        "remotePath": $remote_path
      },
      "mountPath": $mount_path
    }')")
  
  # Add to container volumes array
  container_volumes+=("$local_mount:$container_path")
done <<< "$(echo "$volumes" | tr -s ' ' '\n')"

# Build the JSON array with proper comma separation
task_volumes_json=$(printf '%s,' "${task_volumes[@]}")
task_volumes_json="[${task_volumes_json%,}]"  # Remove trailing comma and add brackets

# Convert container_volumes array to JSON array of strings
container_volumes_json=$(printf '"%s",' "${container_volumes[@]}" | sed 's/,$//')
container_volumes_json="[$container_volumes_json]"


# FIX: empty volumes result in broken json

# Create the complete job configuration
# BATCH_JOB_CONFIG will be used in main script by sourcing this
BATCH_JOB_CONFIG=$(jq -n \
  --arg machine_type "$MACHINE_TYPE" \
  --argjson cpu_milli "$CPU_MILLI" \
  --argjson memory_mib "$MEMORY_MIB" \
  --arg image_uri "$IMAGE_URI" \
  --argjson task_volumes "$task_volumes_json" \
  --argjson container_volumes "$container_volumes_json" \
'{
  "taskGroups": [
    {
      "taskSpec": {
        "computeResource": {
          "cpuMilli": $cpu_milli,
          "memoryMib": $memory_mib
        },
        "runnables": [
          {
            "container": {
              "imageUri": $image_uri,
              "options": "--shm-size=8G",
              "volumes": $container_volumes
            }
          }
        ],
        "volumes": $task_volumes,
        "maxRetryCount": 0,
        "maxRunDuration": "10800s"
      },
      "taskCount": 1,
      "parallelism": 1
    }
  ],
  "allocationPolicy": {
    "instances": [
      {
        "installGpuDrivers": true,
        "policy": {
          "machineType": $machine_type,
        }
      }
    ]
  },
  "logsPolicy": {
    "destination": "CLOUD_LOGGING"
  }
}')
