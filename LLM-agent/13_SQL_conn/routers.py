from state import State

# 라우터 함수. Return 은 다음으로 이어질 Node 의 이름
def route_after_analysis(state: State):
    """query_analysis의 분석 결과에 따라 분기합니다."""
    if state["status"]:
        return "write_sql"
    return "decline_answer"