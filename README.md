# OpenClaw Orchestration POC

This project provides a resource-optimized, containerized agent orchestration system for [OpenClaw](https://openclaw.ai).

## Features
- **Containerized Workers:** Lightweight sub-agents launched on-demand via Docker.
- **Task Queuing:** Sequential processing of heavy tasks to optimize resource usage.
- **Observability:** Real-time task status dashboard and activity logs.

## Setup
1.  **Clone:** `git clone https://github.com/Jaspreet84/openclaw-orchestration-poc.git`
2.  **Infrastructure:** Ensure Docker is installed and your user is in the `docker` group.
3.  **Start Queue Processor:**
    ```bash
    nohup ./scripts/task_queue_processor.sh > tasks/processor.log 2>&1 &
    ```

## Documentation
See [ORCHESTRATION_MANUAL.md](./ORCHESTRATION_MANUAL.md) for detailed operational guides.
