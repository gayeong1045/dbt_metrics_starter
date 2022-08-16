select * 
from {{ metrics.metric(
    metric_name='average_user_cnt',
    grain='week',
    dimensions=[],
) }}