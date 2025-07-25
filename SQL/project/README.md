# SQL mini project

## 프로젝트 준비
1. pgAdmin 에서 새로운 DB(`project`) 생성(Datatbases 우클릭 -> Create)
2. `project` DB 를 클릭하고 Query Tool 버튼을 눌러 새로운 Query 파일 생성 (`prject/postgres@PostgreSQL17` 확인)
3. `chinhook-ddl.sql` 내용을 붙여넣거나 파일을 열고 실행(F5) -> 테이블 생성확인
4. `chinhook_inserts.sql` 내용을 붙여넣거나 파일을 열고 실행(F5) -> 데이터 입력 확인

   ```sql
   SELECT COUNT(*) FROM albums;
   SELECT COUNT(*) FROM artists;
   SELECT COUNT(*) FROM customers;
   SELECT COUNT(*) FROM employees;
   SELECT COUNT(*) FROM genres;
   SELECT COUNT(*) FROM invoices;
   SELECT COUNT(*) FROM playlists;
   SELECT COUNT(*) FROM tracks;

   ```

5. ERD 확인 (아무 테이블이나 우클릭 -> `ERD for table` 로 확인)

## 하 난이도

1. **모든 고객 목록 조회**  
   - 고객의 `customer_id`, `first_name`, `last_name`, `country`를 조회하고, `customer_id` 오름차순으로 정렬하세요.

2. **모든 앨범과 해당 아티스트 이름 출력**  
   - 각 앨범의 `title`과 해당 아티스트의 `name`을 출력하고, 앨범 제목 기준 오름차순 정렬하세요.

3. **트랙(곡)별 단가와 재생 시간 조회**  
   - `tracks` 테이블에서 각 곡의 `name`, `unit_price`, `milliseconds`를 조회하세요.  
   - 5분(300,000 milliseconds) 이상인 곡만 출력하세요.

4. **국가별 고객 수 집계**  
   - 각 국가(`country`)별로 고객 수를 집계하고, 고객 수가 많은 순서대로 정렬하세요.

5. **각 장르별 트랙 수 집계**  
   - 각 장르(`genres.name`)별로 트랙 수를 집계하고, 트랙 수 내림차순으로 정렬하세요.

---

## 중 난이도

1. **직원별 담당 고객 수 집계**  
   - 각 직원(`employee_id`, `first_name`, `last_name`)이 담당하는 고객 수를 집계하세요.  
   - 고객이 한 명도 없는 직원도 모두 포함하고, 고객 수 내림차순으로 정렬하세요.

2. **가장 많이 팔린 트랙 TOP 5**  
   - 판매량(구매된 수량)이 가장 많은 트랙 5개(`track_id`, `name`, `총 판매수량`)를 출력하세요.  
   - 동일 판매수량일 경우 트랙 이름 오름차순 정렬하세요.

3. **2010년 이전에 가입한 고객 목록**  
   - 2010년 1월 1일 이전에 첫 인보이스를 발행한 고객의 `customer_id`, `first_name`, `last_name`, `첫구매일`을 조회하세요.

4. **국가별 총 매출 집계 (상위 10개 국가)**  
   - 국가(`billing_country`)별 총 매출을 집계해, 매출이 많은 상위 10개 국가의 국가명과 총 매출을 출력하세요.

5. **각 고객의 최근 구매 내역**  
   - 각 고객별로 가장 최근 인보이스(`invoice_id`, `invoice_date`, `total`) 정보를 출력하세요.

---

## 상 난이도

1. **월별 매출 및 전월 대비 증감률**  
   - 각 연월(YYYY-MM)별 총 매출과, 전월 대비 매출 증감률을 구하세요.  
   - 결과는 연월 오름차순 정렬하세요.

2. **장르별 상위 3개 아티스트 및 트랙 수**  
   - 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(`artist_id`, `name`, `track_count`)를 구하세요.  
   - 동점일 경우 아티스트 이름 오름차순 정렬.

3. **고객별 총 구매액 및 등급 산출**  
   - 각 고객의 총 구매액을 구하고,  
   - 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.

4. **국가별 재구매율(Repeat Rate)**  
   - 각 국가별로 전체 고객 수, 2회 이상 구매한 고객 수, 재구매율을 구하세요.  
   - 결과는 재구매율 내림차순 정렬.

5. **최근 1년간 월별 신규 고객 및 잔존 고객**  
   - 최근 1년(마지막 인보이스 기준 12개월) 동안,  
   - 각 월별 신규 고객(해당 달에 생애 첫 구매가 일어남) 수와 해당 월에 구매한 기존 고객 수를 구하세요.

---
## 자율 분석
현재 파악한 ERD를 바탕으로 추출할 수 있는 데이터나 정보를 확인할 수 있는 대시보드를 제작

### 예시

1. 음악/고객/매출 관련 창의적 분석
가장 충성도 높은 고객 Top 10 분석

구매 횟수, 총 매출, 평균 구매 간격 등 기준별로 상위 고객을 선정하고 특징 분석

특정 장르 또는 아티스트의 성장 추이

월별/연도별로 특정 장르나 아티스트의 트랙 판매량, 매출 변화 분석

고객의 음악 취향 클러스터링

고객별로 가장 많이 구매한 장르를 파악하고, 유사 고객 그룹(취향별 세그먼트) 도출

직원(지원 담당자)별 고객 만족도 예측

담당 직원별 고객의 재구매율, 평균 구매 금액, 이탈률 등 비교

특정 국가/도시별 인기 음악 스타일

국가·도시별로 가장 많이 팔린 장르, 아티스트, 트랙 순위 분석

2. 추천·마케팅 시나리오
고객별 맞춤 트랙/앨범 추천

최근 구매 이력과 유사 고객의 구매 패턴을 바탕으로 추천 리스트 도출

휴면 고객 재활성화 대상 선정

일정 기간(예: 6개월) 동안 구매 이력이 없는 고객을 찾아, 재구매 가능성이 높은 타겟 추출

장르/아티스트별 프로모션 효과 분석

특정 기간 동안 프로모션이 있었던 장르/아티스트의 매출 증감 효과 측정

3. 데이터 품질 및 이상 탐지
이상 거래 탐지

비정상적으로 높은/낮은 단가, 짧은 시간 내 반복 구매 등 이상 패턴 탐색

데이터 누락/오류 사례 분석

주소, 이메일, 가격 등 주요 필드의 NULL/이상값 빈도 및 원인 파악

4. 서비스·운영 인사이트
플레이리스트 활용 분석

가장 많이 사용된 플레이리스트, 플레이리스트별 트랙 수, 인기 트랙 등 분석

고객 여정 분석

신규 고객이 첫 구매 후 재구매까지 걸리는 평균 기간, 구매 패턴 변화 등 시각화

음원 길이·가격과 판매량의 상관관계

트랙의 재생시간, 단가와 실제 판매량 간의 통계적 상관관계 분석

5. 자유 주제형 탐구
음악 시장 트렌드 예측

최근 1~2년간 데이터로 장르/아티스트별 성장률을 분석하고 향후 트렌드 예측

가상의 신규 상품/서비스 제안

데이터 기반으로 새로운 번들 상품, 추천 시스템, 고객 혜택 프로그램 등 기획안 작성

