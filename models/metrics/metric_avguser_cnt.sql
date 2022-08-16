select * 
from {{ metrics.calculate(
    metric('average_user_cnt'),
    grain='week',
    dimensions=[],
) }}