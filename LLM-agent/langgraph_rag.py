# 12_langgraph_rag.ipynb 파일 총 정리 본
from bs4.filter import SoupStrainer

from langchain_core.tools import tool
from langchain_core.messages import SystemMessage
from langchain_community.document_loaders import WebBaseLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_pinecone import PineconeVectorStore
from langchain_openai import ChatOpenAI

from langgraph.prebuilt import ToolNode, tools_condition
from langgraph.graph import MessagesState, StateGraph, START, END
from langgraph.checkpoint.memory import MemorySaver

###################### RAG 사전작업 ######################
loader = WebBaseLoader(
    web_paths=('https://lilianweng.github.io/posts/2023-06-23-agent/', ),
    bs_kwargs={
        'parse_only': SoupStrainer(class_=['post-content']) 
    }
)
docs = loader.load()

splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splitted_docs = splitter.split_documents(docs)

embedding = OpenAIEmbeddings(model='text-embedding-3-small')  # small <-> large

index_name = 'gaida-1st'
vectorstore = PineconeVectorStore.from_existing_index(index_name=index_name, embedding=embedding)

###################### Tool 정의 ######################
@tool(response_format='content_and_artifact')  # 2개를 return 한다
def retrieve(query: str):
    """Retrieve information related to a query
    Args:
        query : Query to search
    """
    # 원본 Document list (artifact)
    docs = vectorstore.similarity_search(query, k=3)
    # 편집한 텍스트 (content)
    result_text = '\n\n'.join(
        (f'Source: {doc.metadata}\nContent: {doc.page_content}')
        for doc in docs
    )
    return result_text, docs

llm = ChatOpenAI(model='gpt-4.1', temperature=0)

###################### 그래프 Node 생성 ######################
def query_or_respond(state: MessagesState):
    """도구 호출을 하거나, 최종 응답을 한다."""
    llm_with_tools = llm.bind_tools([retrieve])
    guide = SystemMessage(
        content="""
        넌 AI 어시스턴트야. 만약 사용자가 LLM이나 Agent System과 관련된 질문을 하면
        `retrieve` Tool을 사용해야해.
        """
    )
    res = llm_with_tools.invoke([guide] + state['messages'])
    return {'messages': [res]}

tools = ToolNode([retrieve])

def generate(state: MessagesState):
    """응답 생성"""
    tool_messages = []
    for msg in reversed(state['messages']):  # 메세지 목록을 뒤집음: 최신 메세지부터 순회
        if msg.type == 'tool':
            tool_messages.append(msg)
        else:
            break
    tool_messages.reverse()
    docs_content = '\n\n'.join(doc.content for doc in tool_messages)
    system_message_content = (
        "You are an assistant for question-answering tasks. "
        "Use the following pieces of retrieved context to answer "
        "the question. If you don't know the answer, say that you "
        "don't know. Use three sentences maximum and keep the "
        "answer concise."
        "\n\n"
        f"{docs_content}"
    )
    # 필요 없는 Tool 메세지들을 제외하고, AI, Human, System 메시지만 모아서 정리
    conversation_messages = [
        message
        for message in state["messages"]
        if message.type in ("human", "system")
        or (message.type == "ai" and not message.tool_calls)
    ]
    prompt = [SystemMessage(system_message_content)] + conversation_messages

    # Run
    response = llm.invoke(prompt)
    return {"messages": [response]}

###################### 그래프 빌드 ######################
builder = StateGraph(MessagesState) # 'messages'

# builder.add_node('query_or_respond', query_or_respond)  # 아래와 같은 결과
builder.add_node(query_or_respond)
builder.add_node(tools)
builder.add_node(generate)

# builder.set_entry_point('query_or_respond')  # 아래와 같은 말
builder.add_edge(START, 'query_or_respond')
builder.add_conditional_edges(
    'query_or_respond',
    tools_condition,
    {END: END, 'tools': 'tools'}  # 정확하게 상황별 다음 Node 를 지정할 수 있음
)
builder.add_edge('tools', 'generate')
builder.add_edge('generate', END)

memory = MemorySaver()

graph = builder.compile(checkpointer=memory)

