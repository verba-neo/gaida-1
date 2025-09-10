from langgraph.graph import MessagesState

class State(MessagesState):
    question: str  # 사용자 질문
    sql: str       # question을 변환한 SQL
    result: str    # DB에서 받은 결과
    answer: str    # result를 종합하여 생성한 최종 답변
    status: bool   # db에서 해당 정보를 찾을 수 있는지 없는지
    reason: str    # status 결정 이유
