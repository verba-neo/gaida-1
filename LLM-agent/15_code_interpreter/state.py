# State 정의
from langgraph.graph import MessagesState
from typing_extensions import Any


class State(MessagesState):
    question: str        # 사용자 질문
    db_status: bool      # db에서 해당 정보를 찾을 수 있는지 없는지
    db_reason: str       # status 결정 이유
    sql: str             # question을 변환한 SQL
    sql_result: Any      # DB에서 받은 결과
    code: str            # 파이썬 코드 블럭
    code_result: str     # `code`의 실행결과
    answer: str          # 최종 답변
