#!/bin/bash
# scripts/run_tests.sh
echo "=== Running Orchestration v4 Test Suite ==="
export PYTHONPATH=$PYTHONPATH:$(pwd)
pytest tests/
