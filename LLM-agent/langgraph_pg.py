import re
from langchain_community.utilities import SQLDatabase

db = SQLDatabase.from_uri("postgresql://llm_readonly_user:qwer`123@localhost:5432/langgraph")

def safe_run(query: str):
    # 금지된 키워드 필터링
    forbidden = ["insert", "update", "delete", "create", "drop", "alter", "truncate"]
    lowered = query.lower()
    if any(cmd in lowered for cmd in forbidden):
        raise ValueError(f"❌ Unsafe query blocked: {query}")
    return db.run(query)
