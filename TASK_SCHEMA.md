# Task State Schema
Each task is represented by a directory `tasks/<id>/` containing:
- `task.json`: The state object
- `task.log`: The stdout/stderr log

## Schema
{
  "id": "string",
  "status": "pending|processing|completed|failed",
  "retry_count": 0,
  "payload": "string",
  "started_at": "ISO8601",
  "last_updated": "ISO8601"
}
