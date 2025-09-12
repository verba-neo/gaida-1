from typing_extensions import TypedDict, Literal, Annotated
from langchain_openai import ChatOpenAI

from state import State


llm = ChatOpenAI(model='gpt-4o', temperature=0)


# 라우터 함수. Return 은 다음으로 이어질 Node 의 이름
def route_after_analysis(state: State):
    """query_analysis의 분석 결과에 따라 분기합니다."""
    if state["db_status"]:
        return "write_sql"
    return "decline_answer"


class CodeGenerationOutput(TypedDict):
    """SQL로 뽑아낸 데이터를 기반으로 코드 생성 여부 확인"""
    need_to_generate_code: Annotated[Literal[True, False], ..., "코드 생성 필요 여부"]


def should_generate_code(state: State):
    prompt = f'''
    현재의 사용자 질문은 다음과 같다.
    {state['question']}
    ---
    현재 실행한 SQL은 다음과 같다.
    {state['sql']}
    ---
    SQL의 결과는 다음과 같다
    {state['sql_result']}
    ---
    이때 사용자의 질문에 최종 답변을 하기 위해, 
    추가적으로 파이썬 코드를 실행해야 하는지 확인해. (데이터 분석, 머신러닝 등)
    '''

    structured_llm = llm.with_structured_output(CodeGenerationOutput)
    result = structured_llm.invoke(prompt)
    if result['need_to_generate_code']:
        return 'generate_code'
    else:
        return 'generate_answer'