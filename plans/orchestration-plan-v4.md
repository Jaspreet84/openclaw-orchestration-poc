# Architectural Plan: Event-Driven Agent Runtime (v4)

## Review of v3 (The Critique)
Our v3 implementation successfully introduced a JSON-based state machine, retry logic, and webhook callbacks. However, as the Principal Architect, I've identified several scaling bottlenecks:
1. **Synchronous Processing:** The current `task_queue_processor.sh` processes one task at a time. Concurrency is strictly 1. If a worker takes 10 minutes, the queue is blocked.
2. **Language Limitations:** Shell scripts (`bash`, `jq`, `mv`) are fragile for complex state management and concurrency. They lack native error-boundary catching and robust API integrations.
3. **Storage Frailty:** Relying on the filesystem (`tasks/pending/*`) for queuing introduces race conditions if we ever run multiple processor daemons.
4. **Blind Execution:** We use `docker run` via CLI rather than the Docker Engine API, meaning we miss out on fine-grained container lifecycle events (OOM kills, native log streaming).

## The v4 Vision: "Event-Driven Agent Runtime"
We are evolving from a "batch script runner" to a **highly concurrent, event-driven runtime**. 

### Architectural Upgrades
1. **Language Migration:** Migrate the orchestration daemon from Bash to **Python** (or Node.js). This allows thread pools, async I/O, and robust Docker SDK integration.
2. **ACID Task Storage:** Replace the directory-based queue with a lightweight **SQLite database** to ensure atomic state transitions and allow multiple daemon instances to poll safely.
3. **Concurrent Worker Pool:** The daemon will maintain a worker pool (e.g., max 5 concurrent tasks) and launch Docker containers asynchronously.
4. **Dynamic Resource Provisioning:** `task.json` will be expanded so the Dispatcher can request specific resources (e.g., `"resources": {"cpu": 2, "mem": "1g"}`) based on task complexity.

## v4 Backlog

**Phase 1: Foundation Migration**
- [ ] Bootstrap a Python project structure (`requirements.txt`, `main.py`).
- [ ] Implement SQLite database schema to replace `tasks/` directory structure.
- [ ] Write Python database adapter for Task CRUD operations.

**Phase 2: Concurrent Daemon**
- [ ] Implement Python `asyncio` loop to poll the SQLite database.
- [ ] Integrate Docker Python SDK to replace `docker run` CLI commands.
- [ ] Implement worker pool logic (concurrency limits).

**Phase 3: Dispatcher API Integration**
- [ ] Create a lightweight FastAPI endpoint so the OpenClaw Gateway can submit tasks via HTTP POST instead of writing files to disk.
- [ ] Refactor Webhook callback logic into the Python daemon.

**Phase 4: Deprecation**
- [ ] Decommission bash scripts (`worker_orchestrator.sh`, `task_queue_processor.sh`).
