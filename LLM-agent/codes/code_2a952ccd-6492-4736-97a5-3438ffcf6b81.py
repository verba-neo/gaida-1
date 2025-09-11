"""
[USER QUESTION]
키를 기반으로 몸무게를 예측해야해. 키는 173이야.
"""

import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

# 데이터셋 정의
data = {
    'heights': [150, 152, 154, 156, 158, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 185],
    'weights': [45, 48, 49, 50, 52, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 70, 71, 72, 73, 74, 75, 77, 78, 79, 82]
}

# 데이터프레임 생성
df = pd.DataFrame(data)

# 독립 변수와 종속 변수 정의
X = df[['heights']]
y = df['weights']

# 선형 회귀 모델 생성 및 학습
model = LinearRegression()
model.fit(X, y)

# 키 173에 대한 몸무게 예측
height_to_predict = np.array([[173]])
predicted_weight = model.predict(height_to_predict)

print(f"Predicted weight for height 173 cm: {predicted_weight[0]:.2f} kg")