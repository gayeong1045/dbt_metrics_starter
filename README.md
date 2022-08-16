# dbt_metrics 사용 테스트
dbt에서 새로 출시한 기능인 metric을 테스트 사용해봄. 실제 metric 기능 사용을 위한 안정화는 22년 10월 이후일 것으로 보임 

# Metric package 설치
메트릭 기능은 dbt 허브의 [metrics](https://hub.getdbt.com/) package를 설치한 후 사용할 수 있음
## 설치 참고
* dbt 파일 내 `packages.yml` 파일 생성
* 파일 내 아래 코드를 입력하고 `dbt deps` 명령어 실행
```yaml
packages:
  - package: dbt-labs/metrics
    version: 0.3.1
```
*주의사항1 : 위의 0.3.1 버전을 설치하기 위해서는 dbt 최신버전(1.3.0)을 사용해야 함*<br/>
*(Environments 및 `dbt_project.yml` 파일에서 버전을 1.3.0으로 바꾼 후 `dbt compile` 명령어 실행)*

# Metric 사용
솔루션 구매 관련 데이터를 사용하여 아래 데이터를 Metric으로 구성함
* 스키마 정의
```yaml
metrics:
  - name: average_pay_cnt
    label: Average Payment Count
    model: ref('stg_payment')
    type: count_distinct
    sql: user_id
    timestamp: event_at
    time_grains: [day, week, month]
    dimensions:
      - buyer_name
      - custom_data
      - name
    filters:
      - field: status
        operator: '='
        value: "'paid'"

  - name: average_pay_amt
    label: Average Payment Amount
    model: ref('stg_payment')
    type: sum
    sql: amount
    timestamp: event_at
    time_grains: [day, week, month]
    dimensions:
      - buyer_name
      - custom_data
      - name
    filters:
      - field: status
        operator: '='
        value: "'paid'"

  - name: average_payment_per_customer
    label: Average Payment Per Customer
    type: expression
    sql: "{{metric('average_pay_amt')}} / {{metric('average_pay_cnt')}}"
    timestamp: event_at
    time_grains: [day, week, month]
    dimensions:
      - buyer_name
      - custom_data
      - name
```

* 주별 구독종류에 따른 평균 구매횟수
```sql
select * 
from {{ metrics.calculate(
    metric('average_pay_cnt'),
    grain='week',
    dimensions=['custom_data'],
) }}
```
* 주별 구독종류에 따른 총 구매금액
```sql
select * 
from {{ metrics.calculate(
    metric('average_pay_amt'),
    grain='week',
    dimensions=['custom_data'],
) }}
```
* 주별 평균 구매횟수 대비 구매금액
```sql
select * 
from {{ metrics.calculate(
    metric('average_payment_per_customer'), 
    grain='week',
    dimensions=['custom_data'],
    start_date = '2022-01-01',
    end_date = '2022-03-31'
) }}
order by date_week desc
```

*주의사항1 : dbt_metric 최신 버전에서는 metrics.calculate 명령어 사용*<br/>
*주의사항2 : `schema.yml` 파일에서 lable은 입력 필수값임* &nbsp;

#결과
![dbt-dag (4)](https://user-images.githubusercontent.com/72444914/184828478-4778b577-268f-48f8-a8d1-70e5e2c46c5b.png)





