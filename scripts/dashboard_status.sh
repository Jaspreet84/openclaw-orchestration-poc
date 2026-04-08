#!/bin/bash
# scripts/dashboard_status.sh
# Simple observability check for tasks
echo "=== Orchestration Dashboard ==="
echo "Pending: $(ls tasks/pending/ | wc -l)"
echo "Processing: $(ls tasks/processing/ | wc -l)"
echo "Completed: $(ls tasks/completed/ | wc -l)"
echo "Failed: $(ls tasks/failed/ | wc -l)"
