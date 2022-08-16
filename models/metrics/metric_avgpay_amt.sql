select * 
from {{ metrics.calculate(
    metric('average_pay_amt'),
    grain='week',
    dimensions=['custom_data'],
) }}