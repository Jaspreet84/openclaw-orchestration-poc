import pytest
import os
import aiosqlite
from app.database import init_db, DB_PATH

@pytest.mark.asyncio
async def test_db_init():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    await init_db()
    assert os.path.exists(DB_PATH)
    
    async with aiosqlite.connect(DB_PATH) as db:
        async with db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='tasks'") as cursor:
            row = await cursor.fetchone()
            assert row is not None
