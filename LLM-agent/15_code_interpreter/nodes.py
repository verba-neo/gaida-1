import os
import uuid
from typing_extensions import Literal

from langchain_openai import ChatOpenAI
from typing_extensions import TypedDict, Annotated
from langchain_experimental.utilities import PythonREPL
from langchain_core.prompts import ChatPromptTemplate
from langchain_community.tools import QuerySQLDataBaseTool
from langchain_community.utilities import SQLDatabase

from state import State
from db import db, table_info


llm = ChatOpenAI(model='gpt-4.1', temperature=0)


class AnalysisOutput(TypedDict):
    """쿼리 분석 결과"""
    able_to_query: Annotated[Literal[True, False], ..., "답변 생성 가능 여부"]
    reason: Annotated[str, ..., "결정에 대한 짧은 설명"]


# 사용자 질문 분석 Node
def question_analysis(state: State):
    """사용자 질문을 분석하여 답변 가능 여부를 결정하고, 그 결과를 상태에 저장"""
    
    question = state['question']
    prompt = f"""
    너는 데이터분석/머신러닝을 위해 DB에서 데이터를 수집해 오는 어시스턴트다.

    현재 사용자의 질문은 다음과 같다. 
    Question: {question}
    
    ---

    현재 우리 데이터베이스의 테이블 정보는 아래와 같다.
    
    {table_info}
    
    ---

    테이블 정보를 바탕으로 사용자 질문에 답변할 수 있는지, 
    혹은 질문에 답변하기 위한 데이터를 DB에서 수집할 수 있는지
    결정하고 짧은 설명을 덧붙여라.
    """

    structured_llm = llm.with_structured_output(AnalysisOutput)
    result = structured_llm.invoke(prompt)
    return {'db_status': result['able_to_query'], 'db_reason': result['reason'], 'messages': [question]}

    
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
    return {'sql_result': result}



class CodeBlock(TypedDict):
    code: Annotated[str, ..., '바로 실행 가능한 파이썬 코드']


def generate_code(state: State):
    prompt = f'''
    사용자 질문과 데이터셋을 제공할거야. 사용자 질문에 답변하기 위한 파이썬 코드를 생성해 줘.
    코드는 간단할수록 좋고, numpy, pandas, scikit-learn, scipy 가 설치되어 있으니 편하게 사용해.
    [주의] 이 코드는 실행될거기 때문에, 위험한 코드는 작성하면 안돼!
    ---
    질문: {state['question']}
    ---
    데이터셋: {state['sql_result']}
    ---
    코드: 
    '''
    s_llm = llm.with_structured_output(CodeBlock)
    res = s_llm.invoke(prompt)
    return {'code': res['code']}


def execute_code(state: State):
    repl = PythonREPL()
    result = repl.run(state['code'])
    return {'result': result.strip()}


def save_code(state: State):
    """
    코드를 특정 폴더에 저장합니다.
    """
    # 'codes' 폴더가 없으면 생성
    if not os.path.exists("codes"):
        os.makedirs("codes")

    # 고유한 파일 이름 생성
    filename = f"codes/code_{uuid.uuid4()}.py"
    
    # state에서 질문과 코드 가져오기
    question = state.get('question', 'No question provided.')
    code_to_save = state.get('code', '')

    # 질문을 docstring으로 추가
    docstring = f'"""\n[USER QUESTION]\n{question}\n"""\n\n'
    content_to_save = docstring + code_to_save
    
    # 파일에 코드 저장
    with open(filename, "w", encoding="utf-8") as f:
        f.write(content_to_save)
        
    # 상태를 변경하지 않고 다음 노드로 진행하기 위해 빈 딕셔너리 반환
    return {}


def generate_answer(state: State):
    prompt = f'''
    우리는 사용자 질문 -> SQL -> SQL실행결과 ->코드 -> 코드 실행 결과를 가지고 있어
    사용자의 질문과, 나머지를 종합해 최종 답변을 생성해라.
    실행코드를 기반으로 왜 이 결과가 나왔는지 설명하면 된다.
    ---
    질문: {state['question']}
    ---
    SQL: {state['sql']}
    ---
    SQL 결과: {state['sql_result']}
    ---
    코드: {state.get('code', '')}
    ---
    결과: {state.get('code_result', '')}
    ---
    최종 답변:
    '''
    res = llm.invoke(prompt)
    return {'answer': res, 'messages': [res]}


def decline_answer(state: State):
    """DB 관련 정보가 없거나, 데이터가 없을 때 이우를 답변"""
    return {'answer': state['db_reason'], 'messages': [state['db_reason']]}