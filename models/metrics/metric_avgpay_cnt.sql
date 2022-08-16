select * 
from {{ metrics.metric(
    metric_name='average_pay_cnt',
    grain='week',
    dimensions=[],
) }}