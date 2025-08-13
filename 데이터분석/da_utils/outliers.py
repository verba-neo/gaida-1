import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.spatial import distance
from scipy.stats import chi2
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import IsolationForest

import warnings
warnings.filterwarnings('ignore')

# 한글 폰트 설정 (선택사항)
plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False


# 범용 이상치 탐지 함수
def outlier_detection(df: pd.DataFrame, chi_q=0.999, iso_cont=0.1, final_threshold=2):
    
    if df.isna().values.any():
        print('결측치 확인. 처리후 재시도 하세요')
        return 

    print('=== 종합 이상값 탐지 시스템 ===')
    df_copy = df.copy()
    numeric_data = df_copy.select_dtypes(include=['number'])

    # 1. 일(단)변량 IQR 이상값
    print('1. 일변량 이상값 탐지 (IQR방법)')
    univariate_outliers = pd.DataFrame(index=df_copy.index)

    for col in numeric_data.columns:
        Q1 = df_copy[col].quantile(0.25)
        Q3 = df_copy[col].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        outliers_mask = (df_copy[col] < lower_bound) | (df_copy[col] > upper_bound)
        univariate_outliers[col] = outliers_mask
    
        outlier_count = outliers_mask.sum()
        if outlier_count:
            print(f'  {col}: {outlier_count}개 ({outlier_count/len(df_copy) * 100:.1f}%)')

    # 2. 마할라노비스 거리 기반 다변량 이상값 -> 데이터가 정규분포를 따를때
    print('\n2. 다변량 이상값 탐지 (마할라노비스 거리)')
    scaler = StandardScaler()
    
    # 평균0, 표준편차1 로 조정된 데이터
    scaled_df = pd.DataFrame(
        scaler.fit_transform(numeric_data),
        columns=numeric_data.columns,
        index=numeric_data.index
    )
    # 데이터 평균 벡터
    mean = scaled_df.mean().values
    # 공분산 행렬
    cov_matrix = np.cov(scaled_df, rowvar=False)
    # 공분산 행렬의 역행력
    inv_cov_matrix = np.linalg.pinv(cov_matrix)
    # 마할라노비스 거리 계산
    mahal_distance = scaled_df.apply(lambda row: distance.mahalanobis(row, mean, inv_cov_matrix), axis=1)
    
    # 이상치 기준점-임계점(threshold) 지정 (카이제곱 분포 -> 0.95, 0.99, 0.999) -> 이상치의 기준
    threshold = chi2.ppf(chi_q, len(numeric_data.columns)) ** 0.5
    mahal_outliers = mahal_distance > threshold
    print(f'  임계값: {threshold:.2f}')
    print(f'  다변량 이상값: {mahal_outliers.sum()}개 ({mahal_outliers.mean()*100:.1f}%)')
    
    
    # 3. Isolation Forest 기반 다변량 이상값 -> 데이터 이상치가 너무 복잡하게 숨어있을 때
    print('\n3. 다변량 이상값 탐지 (Isolation Forest)')
    iso_forest = IsolationForest(contamination=iso_cont, random_state=42)
    isolation_outliers = iso_forest.fit_predict(scaled_df) == -1
    isolation_scores = iso_forest.score_samples(scaled_df)
    print(f'  Isolation Forest 이상값: {isolation_outliers.sum()}개 ({isolation_outliers.mean()*100:.1f}%)')
    

    # # 4. 비즈니스 규칙(특화) 이상값 - 범용X
    # print('\n4. 비즈니스 규칙 기반 이상값:')
    # business_outliers = (
    #     (df['age'] > 130) |
    #     (df['days_since_last_purchase'] < 0) |
    #     (df['avg_order_value'] > 10000000)
    # )
    # print(f'  비즈니스 규칙 이상값: {business_outliers.sum()}개 ({business_outliers.mean()*100:.1f}%)')

    
    # 5. 종합 판정
    outlier_summary = pd.DataFrame({
        '일변량': univariate_outliers.sum(axis=1) > 0,
        'Mahal Dist': mahal_outliers,
        'Iso Forest': isolation_outliers,
        # '비즈니스': business_outliers,
    })

    outlier_summary['총이상값수'] = outlier_summary.sum(axis=1)
    # 최종 판정 기준
    final_outliers = outlier_summary['총이상값수'] >= final_threshold
    print(f'\n == 최종 이상값: {final_outliers.sum()}개 ({final_outliers.mean()*100:.1f}%)')

    return outlier_summary, final_outliers