from datetime import datetime
from app.models import Task, TaskStatus

def test_task_initialization():
    task = Task(id="test-1", payload="echo hello")
    assert task.id == "test-1"
    assert task.status == TaskStatus.PENDING
    assert task.retry_count == 0
    assert task.max_retries == 3
    assert isinstance(task.last_updated, datetime)

def test_task_status_enum():
    task = Task(id="test-2", payload="test", status="processing")
    assert task.status == TaskStatus.PROCESSING
