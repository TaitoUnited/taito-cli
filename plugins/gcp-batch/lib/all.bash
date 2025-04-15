#!/bin/bash

# Helper function to transform multiline volumes string to list of json objects
function gcp_batch::generate_volume_definitions() {
  local volumes_str=${1:?}

  # Split multiline volumes string into single elements with in:out pairs
  read -ra volume_pairs <<< "$(echo "$volumes_str" | tr '\n' ' ')"

  local volume_json_objects=()
  local pair gcs_path container_path remote_path last_component local_mount vol_obj

  for pair in "${volume_pairs[@]}"; do
    # Validate format: must contain gs:// and a colon followed by an absolute path (/ prefix)
    if [[ ! "$pair" =~ ^gs://.+:/.+ ]]; then
      echo "Invalid volume format: '$pair'. Expected 'gs://bucket/path:/container/path'" >&2
      return 1
    fi

    # Split at the last colon
    gcs_path="${pair%:*}"
    container_path="${pair##*:}"

    # Extract remote path (part after gs://bucket/)
    if [[ "$gcs_path" =~ ^gs://[^/]+/(.+)$ ]]; then
        remote_path="${BASH_REMATCH[1]}"
    elif [[ "$gcs_path" =~ ^gs://[^/]+/?$ ]]; then
        # Handle case like gs://bucket or gs://bucket/ where there's no real path part
         echo "GCS path '$gcs_path' must specify a path within the bucket (e.g., gs://bucket/data)." >&2
         return 1
    else
        # Should not happen due to initial regex check, but good for safety
        echo "Could not parse GCS remote path from '$gcs_path'." >&2
        return 1
    fi

    # Define local mount path based on the *last component* of the GCS path
    # Handle potential trailing slash in remote_path before getting basename
    last_component=$(basename "${remote_path%/}")
    if [[ -z "$last_component" || "$last_component" == "." || "$last_component" == "/" ]]; then
       echo "Cannot determine a valid local mount name from GCS path '$gcs_path' (basename is empty or '.')." >&2
       return 1
    fi
    # Standard mount point prefix used by Batch GCS mounts
    local_mount="/mnt/disks/gcs/${last_component}"

    # Create a JSON object for this volume using jq for safety
    vol_obj=$(jq -cn \
      --arg rp "$remote_path" \
      --arg mp "$local_mount" \
      --arg cp "$container_path" \
      '{remotePath: $rp, mountPath: $mp, containerPath: $cp}')
    volume_json_objects+=("$vol_obj")
  done

  # Combine individual JSON objects into a single JSON array string using jq
  printf '%s\n' "${volume_json_objects[@]}" | jq -sc '.'
}


function gcp_batch::build_config() {
  if [[ $# -lt 4 || $# -gt 5 ]]; then
    echo "Usage: gcp_batch::build_config <machine_type> <image_tag> <cpu_milli> <memory_mib> <volumes_str>" >&2
    return 1
  fi

  local machine_type=${1:?}
  local image_tag=${2:?}
  local cpu_milli=${3:?}
  local memory_mib=${4:?}
  local volumes_str=${5:?}

  # Validate numeric inputs
  if ! [[ "$cpu_milli" =~ ^[0-9]+$ ]]; then
    echo "cpu_milli must be an integer. Received: '$cpu_milli'" >&2
    return 1
  fi
  if ! [[ "$memory_mib" =~ ^[0-9]+$ ]]; then
    echo "memory_mib must be an integer. Received: '$memory_mib'" >&2
    return 1
  fi

  # We will create a JSON array of objects, where each object represents a volume mapping.
  # This allows jq to process it easily later.
  local volumes_jq_input="[]" # Default to an empty JSON array
  if [[ -n "$volumes_str" ]]; then
    volumes_jq_input=$(gcp_batch::generate_volume_definitions "$volumes_str")
  fi


  # --- Build the Final JSON Configuration using jq ---
  # Pass all variables and the pre-processed volume data to a single jq command.
  jq -n \
    --arg machine_type "$machine_type" \
    --arg image_uri "$image_tag" \
    --argjson cpu_milli "$cpu_milli" \
    --argjson memory_mib "$memory_mib" \
    --argjson volumes_data "$volumes_jq_input" \
    '
    ($volumes_data | map({gcs: {remotePath: .remotePath}, mountPath: .mountPath})) as $task_volumes
    | ($volumes_data | map("\(.mountPath):\(.containerPath)")) as $container_volumes
    |
    {
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
              "machineType": $machine_type
            }
          }
        ]
      },
      "logsPolicy": {
        "destination": "CLOUD_LOGGING"
      }
    }
    '
}
