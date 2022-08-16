select * 
from {{ metrics.calculate(
    metric('average_payment_per_customer'), 
    grain='week',
    dimensions=[],
    start_date = '2022-01-01',
    end_date = '2022-03-31'
) }}
order by date_week desc