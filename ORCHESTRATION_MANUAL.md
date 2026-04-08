# Orchestration System Manual

This repository contains the orchestration logic for autonomous agent scaling.

## Directory Structure
- `scripts/`: Worker orchestrator, queue processor, and observability tools.
- `tasks/`: Task queue (pending, processing, completed, failed).

## Usage
1. **Queue a Task:** `echo "task-data" > tasks/pending/task-id`
2. **Monitor:** `./scripts/dashboard_status.sh`
3. **Debug:** `tasks/processing/task-id.log`

## Deployment
The queue processor runs as a background process:
```bash
nohup ./scripts/task_queue_processor.sh > tasks/processor.log 2>&1 & echo $! > tasks/processor.pid
```
