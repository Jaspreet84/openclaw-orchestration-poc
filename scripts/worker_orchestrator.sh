#!/bin/bash
# Improved worker: JSON-contract compliant
TASK_DIR=$1
TASK_ID=$(basename "$TASK_DIR")
JSON_FILE="$TASK_DIR/task.json"

# Set status to processing
jq -r --arg NOW "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.status = "processing" | .started_at = $NOW' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

# Execute
docker run --rm --memory="512m" --cpus="0.5" alpine sh -c "echo 'Worker processed: $(cat $JSON_FILE | jq -r .payload)'" > "$TASK_DIR/task.log" 2>&1
EXIT_CODE=$?

# Update final status
if [ $EXIT_CODE -eq 0 ]; then
    jq '.status = "completed"' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
else
    jq '.status = "failed"' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
fi
exit $EXIT_CODE
