from langgraph.graph import START, END, StateGraph
from state import State
from nodes import question_analysis, generate_answer, write_sql, execute_sql, decline_answer
from routers import route_after_analysis


builder = StateGraph(State)

builder.add_node('question_analysis', question_analysis)
builder.add_node("write_sql", write_sql)
builder.add_node("execute_sql", execute_sql)
builder.add_node("generate_answer", generate_answer)
builder.add_node("decline_answer", decline_answer)

builder.add_edge(START, 'question_analysis')
builder.add_conditional_edges('question_analysis', route_after_analysis, {
    "write_sql": "write_sql",
    "decline_answer": "decline_answer"
})
builder.add_edge("write_sql", "execute_sql")
builder.add_edge("execute_sql", "generate_answer")
builder.add_edge("generate_answer", END)
builder.add_edge("decline_answer", END)

app = builder.compile()

if __name__ == '__main__':
    from pprint import pprint
    res = app.invoke(
        {
            "question": "가장 적은 돈을 쓴 나라는?"
        }
    )

    pprint(res)