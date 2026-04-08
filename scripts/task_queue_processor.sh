#!/bin/bash
# scripts/task_queue_processor.sh
# Monitors tasks/pending/ and moves them to processing/

while true; do
    PENDING=$(ls tasks/pending/ | head -n 1)
    if [ -n "$PENDING" ]; then
        mv tasks/pending/"$PENDING" tasks/processing/
        ./scripts/worker_orchestrator.sh "$PENDING" > tasks/processing/"$PENDING".log 2>&1
        if [ $? -eq 0 ]; then
            mv tasks/processing/"$PENDING" tasks/completed/
            rm tasks/processing/"$PENDING".log
        else
            mv tasks/processing/"$PENDING" tasks/failed/
            echo "Task $PENDING failed. See tasks/processing/$PENDING.log"
        fi
    fi
    sleep 5
done
