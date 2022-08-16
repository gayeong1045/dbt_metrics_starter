select * 
from {{ metrics.calculate(
    metric('average_pay_cnt'),
    grain='week',
    dimensions=['custom_data'],
) }}