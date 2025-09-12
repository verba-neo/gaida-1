from state import State
from nodes import (
    question_analysis, write_sql, execute_sql,
    generate_code, execute_code, save_code,
    generate_answer, decline_answer,
)
from routers import route_after_analysis, should_generate_code
# builder 를 만들고 최종 compile() 을 실행하는 곳
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.memory import InMemorySaver

builder = StateGraph(State)

builder.add_node('question_analysis', question_analysis)
builder.add_node('write_sql', write_sql)
builder.add_node('execute_sql', execute_sql)
builder.add_node('generate_code', generate_code)
builder.add_node('execute_code', execute_code)
builder.add_node('save_code', save_code)
builder.add_node('generate_answer', generate_answer)
builder.add_node('decline_answer', decline_answer)

builder.add_edge(START, 'question_analysis')
builder.add_conditional_edges(
    'question_analysis',
    route_after_analysis,
    {'write_sql': 'write_sql', 'decline_answer': 'decline_answer'}     
)
builder.add_edge('write_sql', 'execute_sql')
builder.add_conditional_edges(
    'execute_sql',
    should_generate_code,
    {'generate_code': 'generate_code', 'generate_answer': 'generate_answer'}   
)
builder.add_edge('generate_code', 'execute_code')
builder.add_edge('execute_code', 'save_code')
builder.add_edge('save_code', 'generate_answer')
builder.add_edge('generate_answer', END)


# langgraph dev
graph = builder.compile()

# streamlit
# memory = InMemorySaver()
# # 모든 노드 이후에 중단이 가능하도록 설정
# all_nodes = list(builder.nodes.keys())
# app = builder.compile(checkpointer=memory, interrupt_after=all_nodes)

