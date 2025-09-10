from typing_extensions import Annotated, TypedDict, Literal
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_community.tools import QuerySQLDataBaseTool

from state import State
from db import db, table_info

llm = ChatOpenAI(model='gpt-4.1', temperature=0)


class AnalysisOutput(TypedDict):
    """쿼리 분석 결과"""
    able_to_query: Annotated[Literal[True, False], ..., "SQL 쿼리 가능 여부"]
    rejection_reason: Annotated[str, ..., "결정에 대한 간략한 설명"]


# 사용자 질문 분석 Node
def question_analysis(state: State):
    """사용자 질문을 분석하여 SQL 생성 필요 여부를 결정하고, 그 결과를 상태에 저장"""
    prompt = f"""

    현재 사용자의 질문은 다음과 같다. 
    {state['question']}
    
    ---

    현재 우리 데이터베이스의 테이블 정보는 아래와 같다.
    {table_info}
    
    ---

    테이블 정보를 바탕으로 사용자 질문에 답변할 수 있는지를 결정하고 설명을 덧붙여라.
    """

    structured_llm = llm.with_structured_output(AnalysisOutput)
    result = structured_llm.invoke(prompt)
    return {'status': result['able_to_query'], 'reason': result['rejection_reason']}

    
# write_sql 에서 사용
class QueryOutput(TypedDict):
    """Generate SQL query"""
    query: Annotated[str, ..., '문법적으로 올바른 SQL 쿼리']


# SQL 생성 Node
def write_sql(state: State):
    """Generate SQL query to fetch info"""
    system_message = """
    Given an input question, create a syntactically correct {dialect} query to
    run to help find the answer. Unless the user specifies in his question a
    specific number of examples they wish to obtain, always limit your query to
    at most {top_k} results. You can order the results by a relevant column to
    return the most interesting examples in the database.

    Never query for all the columns from a specific table, only ask for a the
    few relevant columns given the question.

    Pay attention to use only the column names that you can see in the schema
    description. Be careful to not query for columns that do not exist. Also,
    pay attention to which column is in which table.

    Only use the following tables:
    {table_info}
    """
    user_prompt = "Question: {input}"
    query_prompt_template = ChatPromptTemplate(
        [
            ('system', system_message),
            ('user', user_prompt),
        ]
    )
    prompt = query_prompt_template.invoke({
        "dialect": db.dialect,
        "top_k": 10,
        "table_info": table_info,
        "input": state["question"],
    })
    structured_llm = llm.with_structured_output(QueryOutput)
    result = structured_llm.invoke(prompt)
    return {'sql': result["query"]}


# SQL실행 노드
def execute_sql(state: State):
    """Execute SQL Query"""
    execute_query_tool = QuerySQLDataBaseTool(db=db)
    result = execute_query_tool.invoke(state['sql'])
    return {'result': result}

# 답변 생성 노드
def generate_answer(state: State):
    """질문에 대해 수집한 정보를 바탕으로 답변"""
    prompt = f"""
    주어진 사용자 질문에 대해, DB에서 실행할 SQL 쿼리와 결과를 바탕으로 답변해.

    Question: {state['question']}
    ---
    SQL Query: {state['sql']}
    SQL Result: {state['result']}
    """
    res = llm.invoke(prompt)
    return {'answer': res.content}


def decline_answer(state: State):
    """DB 관련 정보가 없거나, 데이터가 없을 때 이우를 답변"""
    return {'answer': state['reason']}
