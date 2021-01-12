from faker import Faker
import random

# random.choice
USER: list = []  # border/
ORDER: list = []  # dependent: USER
GOODS: list = []  # dependent: ORDER
EVALUATION: list = []  # dependent: ORDER
VEHICLE: list = []  # border/
TRANSFER_STATION: list = []  # dependent: USER
TRANSPORT_FRAGMENT: list = []  # dependent: ORDER, TRANSFER_STATION, USER, VEHICLE

f = Faker(locale='zh_CN')


def user(n: int):
    global USER
    for i in range(n):
        _d = {
            "user_id": i,
            "user_name": f.name(),
            "user_type": "C" if i % 50 == 0 else "E",
            "telephone_number": 100_0000_0000 + i,
            "payment": random.choice(["yearly", "quarterly", "monthly", "daily", "advance", "collect"])
        }
        USER.append(_d)


def vehicle(n: int):
    global VEHICLE
    for i in range(n):
        # 小电车503 / 面包车221 / 货柜车23 / 火车7 / 飞机3 / 轮船1
        if i % 503 == 0:
            _type = "轮船"
        elif i % 221 == 0:
            _type = "飞机"
        elif i % 23 == 0:
            _type = "火车"
        elif i % 7 == 0:
            _type = "货柜车"
        elif i % 3 == 0:
            _type = "面包车"
        else:
            _type = "小电车"

        _brand = _type[0] + random.choice(["a", "b", "c", "d", "f"])
        _license_number = _brand + "/" + str(i)
        _d = {
            "vehicle_id": i,
            "type": _type,
            "brand": _brand,
            "license_number": _license_number,
            "worth": round(random.uniform(1_000, 1_000_000), 2)
        }
        VEHICLE.append(_d)


if __name__ == '__main__':
    user(100)
    print(USER)
