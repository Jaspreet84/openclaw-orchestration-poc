#!/bin/bash
# scripts/worker_orchestrator.sh
# Improved orchestrator: Trigger worker container with cleanup and error handling

TASK_PAYLOAD=$1
WORKER_NAME="worker-$(date +%s)-$RANDOM"

echo "[$(date)] Starting worker container for task: $TASK_PAYLOAD"

# Trap to ensure cleanup happens even if the script is terminated
cleanup() {
    echo "[$(date)] Cleaning up container $WORKER_NAME..."
    docker rm -f $WORKER_NAME >/dev/null 2>&1
}
trap cleanup EXIT

# Run container with resource limits and automatic cleanup
docker run --rm \
    --name $WORKER_NAME \
    --memory="512m" \
    --cpus="0.5" \
    alpine sh -c "echo 'Worker received: $TASK_PAYLOAD' && sleep 2 && exit 0"

# Result capture
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "[$(date)] Task $TASK_PAYLOAD completed successfully."
else
    echo "[$(date)] Task $TASK_PAYLOAD failed with exit code $EXIT_CODE."
    exit $EXIT_CODE
fi
