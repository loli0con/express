import random

ts_2020_1_1 = 1577808000
ts_2021_1_1 = 1609430400
ts_2020_12_1 = 1606752000
ONE_HOUR = 3600
ONE_DAY = 86400


def get_a_time_before_12_month():
    return random.randint(ts_2020_1_1, ts_2020_12_1)
