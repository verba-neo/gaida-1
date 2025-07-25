# main.py
'''
터미널에서 아래 두줄 터미널에서 설치 해야함
pip install fastapi
pip install uvicorn[standard]

터미널에서 현재 파일의 위치로 이동(cd) 이후 명령어로 서버 켬
uvicorn main:app --reload
'''
from fastapi import FastAPI, Request
import requests
from dotenv import load_dotenv
import os
from openai import OpenAI

# .env 파일을 불러옴
load_dotenv()
app = FastAPI()


def send_message(chat_id, message):
    # .env 에서 'TELEGRAM_BOT_TOKEN'에 해당하는 값을 불러옴
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')

    URL = f'https://api.telegram.org/bot{bot_token}'
    body = {
        # 사용자 chat_id 는 어디서 가져옴..?
        'chat_id': chat_id,
        'text': message,
    }
    requests.get(URL + '/sendMessage', body)
    

# /telegram 라우팅으로 텔레그램 서버가 Bot에 업데이트가 있을 경우, 우리에게 알려줌
@app.post('/telegram')
async def telegram(request: Request):
    print('텔레그램에서 요청이 들어왔다!!!!')
    
    data = await request.json()
    print(data)
    sender_id = data['message']['chat']['id']
    input_msg = data['message']['text']

    client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
    
    res = client.responses.create(
        model='gpt-4.1-mini',
        input=input_msg,
        instructions='너는 초등학교 선생님이야. 모든 질문에 친절하게 설명해줘.',
        temperature=0
    )

    send_message(sender_id, res.output_text)

    return {'status': '굿'}
