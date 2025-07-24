# main.py
'''
터미널에서 아래 두줄 터미널에서 설치 해야함
pip install fastapi
pip install uvicorn[standard]

이후 아래 터미널 명령어로 서버 켬
uvicorn main:app --reload
'''

from fastapi import FastAPI
import random
import requests

app = FastAPI()


@app.get('/hi')
def hi():
    return {'status': '굿'}


@app.get('/lotto')
def lotto():
    return {
        'numbers': random.sample(range(1, 46), 6)
    }


@app.get('/gogogo')
def gogogo():
    bot_token = '8094231169:AAGEmcVeMvUSbhpbHmJPT0dgKx7NjstQtQ8'
    URL = f'https://api.telegram.org/bot{bot_token}'
    body = {
        'chat_id': '765946187',
        'text': '이 메시지는 서버가 보냄', 
    }
    requests.get(URL + '/sendMessage', body)
    return {'status': 'gogogo'}