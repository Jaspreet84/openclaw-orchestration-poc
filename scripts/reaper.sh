#!/bin/bash
# scripts/reaper.sh - Marks stalled tasks as failed
for d in tasks/processing/*/; do
    [ -d "$d" ] || continue
    LAST_UPD=$(stat -c %Y "$d/task.json")
    NOW=$(date +%s)
    DIFF=$((NOW - LAST_UPD))
    if [ $DIFF -gt 300 ]; then # 5 minutes
        echo "[$(date)] Reaper: Task $d stalled. Marking failed."
        # Update JSON to failed
        jq '.status = "failed"' "$d/task.json" > "$d/task.json.tmp" && mv "$d/task.json.tmp" "$d/task.json"
        mv "$d" tasks/failed/
    fi
done
