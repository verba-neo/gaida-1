"""
[USER QUESTION]
최고 매출을 한 고객을 찾아내서 그 사람의 다음달 구매액을 예측해보자.
"""

import pandas as pd
from decimal import Decimal

# 데이터셋 생성
data = [(6, 'Helena', 'Holý', Decimal('49.62'))]
df = pd.DataFrame(data, columns=['customer_id', 'first_name', 'last_name', 'sales'])

# 최고 매출 고객 찾기
max_customer = df.loc[df['sales'].idxmax()]

# 다음달 구매액 예측 (여기서는 데이터가 1개뿐이므로, 동일하다고 가정)
predicted_next_month_sales = max_customer['sales']

print(f"최고 매출 고객: {max_customer['first_name']} {max_customer['last_name']}")
print(f"예측된 다음달 구매액: {predicted_next_month_sales}")
