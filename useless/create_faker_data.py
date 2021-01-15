from faker import Faker
import random
from useless import time_lib

# 用户表
USER: list = []  # border/
customer_number = 100_000  # 客户个数
employee_number = 4000  # 员工个数
customer_min_id = 100_0000_0000  # 最小客户编号
employee_min_id = 200_0000_0000  # 最小员工编号

ORDER: list = []  # dependent: USER
GOODS: list = []  # dependent: ORDER
EVALUATION: list = []  # dependent: ORDER

# 运输工具表
VEHICLE: list = []  # border/
vehicle_number = {
    "小电车": 2000,  # 负责街道运输
    "面包车": 400,  # 市内运输
    "货柜车": 200,
    "火车": 15,
    "飞机": 10,
    "轮船": 5,
}

TRANSFER_STATION: list = []  # dependent: USER
station_id = 1  # 全局仓库编号
express_cover_city = [  # 业务覆盖范围
    "中国|湖北|武汉",  # 内陆
    "中国|广东|深圳",  # 沿海
    "日本|关东|东京",  # 外国
]
locations = []

TRANSPORT_FRAGMENT: list = []  # dependent: ORDER, TRANSFER_STATION, USER, VEHICLE

f = Faker(locale='zh_CN')


# 引入员工和客户，创建系统用户
def create_user():
    global USER

    # 生成客户
    temp_settlement_list = ["yearly", "quarterly", "monthly", "once"]
    for i in range(customer_number):
        id_and_phone = customer_min_id + i
        _d = {
            "user_id": id_and_phone,
            "user_name": f.name() + str(id_and_phone),
            "user_type": "C",
            "telephone_number": id_and_phone,
            "payment": random.choice(temp_settlement_list)
        }
        USER.append(_d)

    # 生成员工
    temp_settlement_list = ["yearly", "quarterly", "daily"] + ["monthly"] * 7
    for i in range(employee_number):
        id_and_phone = employee_min_id + i
        _d = {
            "user_id": id_and_phone,
            "user_name": f.name() + str(id_and_phone),
            "user_type": "E",
            "telephone_number": id_and_phone,
            "payment": random.choice(temp_settlement_list)
        }
        USER.append(_d)

    # 生成系统用户
    USER.append({
        "user_id": 0,
        "user_name": "system_user",
        "user_type": "S",
        "telephone_number": None,
        "payment": None
    })


# 购入车辆，或者是使用其他运输公司提供的火车/飞机/轮船的服务
def create_vehicle():
    global VEHICLE
    _id = 1  # 全表的ID，所有交通工具的编号
    for vehicle, number in vehicle_number.items():
        # vehicle:交通工具的种类名
        for i in range(number):
            # i:某个交通工具的编号
            _brand = vehicle + "品牌" + random.choice(["a", "b", "c", "d"])
            _d = {
                "vehicle_id": _id,
                "type": vehicle,
                "brand": _brand,
                "license_number": vehicle + str(i),
                "worth": round(random.uniform(1_000, 1_000_000), 2)
            }
            VEHICLE.append(_d)
            _id += 1


# 创建快递站点
def create_express_station():
    # 生成规则，假定城市地图是规则的图形化
    # 一个城市对应：
    # 1个一级仓库（市级-核心枢纽
    # 4个二级仓库（区级-东西南北分流）
    # 4*4个三级仓库（街道-区内分流）

    global locations
    # 设置location
    locations = []
    locations += [
        city + "|市级仓库"
        for city in express_cover_city
    ]
    locations += [
        city + "|" + position + "区仓库"
        for city in express_cover_city
        for position in ["东", "南", "西", "北"]
    ]
    locations += [
        city + "|" + position + letter + "街道"
        for city in express_cover_city
        for position in ["东", "南", "西", "北"]
        for letter in ["A", "B", "C", "D"]
    ]

    global station_id
    for i, location in enumerate(locations):
        # 设置nickname
        if "街道" in location:
            nickname = location + "｜小猪驿站"
        else:
            nickname = location

        # 设置type
        if "街道" in location:
            _type = "三级仓库"
        elif "区仓库" in location:
            _type = "二级仓库"
        else:
            _type = "一级仓库"

        _d = {
            "station_id": station_id,
            "nickname": nickname,
            "location": location,
            "type": _type,
            "creator": 0,  # 由系统创建
            "manager": i + employee_min_id
        }
        station_id += 1

        TRANSFER_STATION.append(_d)


# 创建订单以及所有的业务数据
def create_order():
    # 用user_id查出user对象
    def get_user(user_id):
        for item in USER:
            if item["user_id"] == user_id:
                return item

    # 变量
    order_id = 1  # 初始值
    expect_deliver_time_frame_list = ["上午", "下午", "晚上"]
    service_type_list = ["即时送", "京尊达", "冷运", "国际"]
    express_type_list = ["当天", "明天", "后天", "普通"]
    # 所有订单都在2020年内

    # 迭代所有用户
    for customer_id in range(customer_min_id, customer_number):
        # 已经完成的订单
        for _ in range(random.randint(0, 10)):
            if get_user(customer_id).get("payment") == "once":  # 非记账用户
                pay_type = random.choice(["预付", "到付"])
            else:
                pay_type = random.choice(["预付", "到付", "记账"])
            _d = {
                "order_id": order_id,
                "customer_id": customer_id,
                "status": "完成",
                "create_time": time_lib.get_a_time_before_12_month(),
                "expect_deliver_time_frame": random.choice(expect_deliver_time_frame_list),
                "payment": random.randint(8, 50),
                "pay_type": pay_type,
                "is_paid": "T" if pay_type != "记账" else random.choice("TF"),
                "express_type": random.choice(express_type_list),
                "service_type": random.choices(service_type_list, k=random.randint(0, len(service_type_list)))
            }


if __name__ == '__main__':
    print(USER)
