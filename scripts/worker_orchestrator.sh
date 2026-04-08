#!/bin/bash
TASK_DIR=$1
JSON_FILE="$TASK_DIR/task.json"

# Set status to processing
jq -r --arg NOW "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.status = "processing" | .started_at = $NOW' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

# Execute container
docker run --rm --memory="512m" --cpus="0.5" alpine sh -c "echo 'Worker processed: $(cat $JSON_FILE | jq -r .payload)'" > "$TASK_DIR/task.log" 2>&1
exit $?
