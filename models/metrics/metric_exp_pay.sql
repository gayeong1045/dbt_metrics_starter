select * 
from {{ metrics.metric(
    metric_name='average_pay_per_customer',
    grain='week',
    dimensions=['custom_data'],
) }}