select * 
from {{ metrics.metric(
    metric_name='average_pay_amt',
    grain='week',
    dimensions=['custom_data'],
) }}