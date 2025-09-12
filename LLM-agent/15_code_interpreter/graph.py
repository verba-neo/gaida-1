from state import State

# builder 를 만들고 최종 compile() 을 실행하는 곳
from langgraph.graph import StateGraph, START, END

builder = StateGraph(State)

builder.add_edge(START, END)

graph = builder.compile()