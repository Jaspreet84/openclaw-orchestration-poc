import aiosqlite
import json
import os

DB_PATH = "tasks.db"

async def init_db():
    async with aiosqlite.connect(DB_PATH) as db:
        await db.execute("""
            CREATE TABLE IF NOT EXISTS tasks (
                id TEXT PRIMARY KEY,
                status TEXT NOT NULL,
                payload TEXT NOT NULL,
                retry_count INTEGER DEFAULT 0,
                max_retries INTEGER DEFAULT 3,
                started_at TEXT,
                last_updated TEXT,
                exit_code INTEGER
            )
        """)
        await db.commit()
