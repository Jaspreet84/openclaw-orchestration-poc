import enum
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field

class TaskStatus(str, enum.Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"

class Task(BaseModel):
    id: str
    status: TaskStatus = TaskStatus.PENDING
    payload: str
    retry_count: int = 0
    max_retries: int = 3
    started_at: Optional[datetime] = None
    last_updated: datetime = Field(default_factory=datetime.utcnow)
    exit_code: Optional[int] = None
