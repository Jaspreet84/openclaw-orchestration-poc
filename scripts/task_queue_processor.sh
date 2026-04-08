#!/bin/bash
while true; do
    for f in tasks/pending/*/; do
        [ -d "$f" ] || continue
        TASK_ID=$(basename "$f")
        mv "$f" tasks/processing/
        PROC_DIR="tasks/processing/$TASK_ID"
        
        ./scripts/worker_orchestrator.sh "$PROC_DIR"
        EXIT_CODE=$?
        
        if [ $EXIT_CODE -eq 0 ]; then
            jq '.status = "completed"' "$PROC_DIR/task.json" > "$PROC_DIR/task.json.tmp" && mv "$PROC_DIR/task.json.tmp" "$PROC_DIR/task.json"
            mv "$PROC_DIR" tasks/completed/
        else
            # Retry Logic
            RETRY_COUNT=$(jq .retry_count "$PROC_DIR/task.json")
            MAX_RETRIES=$(jq .max_retries "$PROC_DIR/task.json")
            
            if [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; then
                NEW_RETRY=$((RETRY_COUNT + 1))
                echo "[$(date)] Task $TASK_ID failed (Code $EXIT_CODE). Retry $NEW_RETRY/$MAX_RETRIES"
                jq --argjson r "$NEW_RETRY" '.retry_count = $r | .status = "pending"' "$PROC_DIR/task.json" > "$PROC_DIR/task.json.tmp" && mv "$PROC_DIR/task.json.tmp" "$PROC_DIR/task.json"
                mv "$PROC_DIR" tasks/pending/
            else
                echo "[$(date)] Task $TASK_ID exhausted retries."
                jq '.status = "failed"' "$PROC_DIR/task.json" > "$PROC_DIR/task.json.tmp" && mv "$PROC_DIR/task.json.tmp" "$PROC_DIR/task.json"
                mv "$PROC_DIR" tasks/failed/
            fi
        fi
    done
    sleep 5
done
