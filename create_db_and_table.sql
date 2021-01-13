DROP DATABASE IF EXISTS express;
CREATE DATABASE IF NOT EXISTS express;
USE express;

CREATE TABLE IF NOT EXISTS User_
(
    user_id          INT AUTO_INCREMENT, #用户id
    user_name        VARCHAR(255),       #用户名
    user_type        CHAR(1),            #用户类型，C客户/E雇员/V虚拟用户/S系统用户
    telephone_number VARCHAR(255),       #联系方式，暂定为手机号码
    payment          VARCHAR(255),       #支付方式，按年/季/月/日/次支付
    PRIMARY KEY (user_id)
); #用户


CREATE TABLE IF NOT EXISTS Order_
(
    order_id                  INT AUTO_INCREMENT,                  #订单编号
    customer_id               INT,                                 #顾客ID
    status                    VARCHAR(255),                        #订单状态，进行中/中断/完成
    create_time               TIMESTAMP DEFAULT CURRENT_TIMESTAMP, #订单创建时间
    expect_deliver_time_frame VARCHAR(255),                        #期待派送时间段，例如11:00-18:00
    payment                   DOUBLE,                              #订单价格
    pay_type                  VARCHAR(255),                        #支付类型，预付/到付/记账/免付
    is_paid                   CHAR(1)   DEFAULT 'F',               #是否已付款，T/F
    express_type              VARCHAR(255),                        #快递类型，顺风标快/顺风特快
    service_type              VARCHAR(255),                        #服务类型，即时送|京尊达|冷运|国际
    is_deliver_on_time        CHAR(1)   DEFAULT NULL,              #是否按时送达
    weight                    DOUBLE,                              #包裹重量
    package_type              VARCHAR(255),                        #包装，扁平信封/小盒子/大盒子/大物件
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES User_ (user_id)
); #订单

CREATE TABLE IF NOT EXISTS Goods
(
    package_id INT,          #包裹ID，即订单ID
    goods_name VARCHAR(255), #物品名字
    worth      DOUBLE,       #物品价值
    FOREIGN KEY (package_id) REFERENCES Order_ (order_id)
); #运输货物

CREATE TABLE IF NOT EXISTS Evaluation
(
    order_id INT,          #订单ID
    score    INT,          #评分
    content  VARCHAR(255), #评价内容
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id)
); #订单评价

CREATE TABLE IF NOT EXISTS Vehicle
(
    vehicle_id     INT AUTO_INCREMENT, #工具ID，系统内部编号
    type           VARCHAR(255),       #工具类型，小电车/面包车/货柜车/火车/飞机/轮船
    brand          VARCHAR(255),       #品牌
    license_number VARCHAR(255),       #牌号，例如车牌号等社会性质的外部编号
    worth          DOUBLE,             #估价
    PRIMARY KEY (vehicle_id)
); #运输工具/交通工具

CREATE TABLE IF NOT EXISTS TransferStation
(
    station_id INT AUTO_INCREMENT, #结点ID
    nickname   VARCHAR(255),       #结点昵称
    location   VARCHAR(255),       #结点位置
    type       VARCHAR(255),       #结点类型，例如用户地址/一级仓库/二级仓库/三级仓库/四级仓库/中转站/断点
    creator    INT,                #结点创建者
    manager    INT,                #结点管理者
    PRIMARY KEY (station_id),
    FOREIGN KEY (creator) REFERENCES User_ (user_id),
    FOREIGN KEY (manager) REFERENCES User_ (user_id)
); #运输结点

CREATE TABLE IF NOT EXISTS TransportFragment
(
    fragment_id          INT AUTO_INCREMENT, #片段ID
    road_map             VARCHAR(255),       #路线描述
    fragment_description VARCHAR(255),       #片段描述
    expected_start_time  TIMESTAMP,          #期望开始时间
    actual_start_time    TIMESTAMP,          #实际开始时间
    expected_ending_time TIMESTAMP,          #期望结束时间
    actual_ending_time   TIMESTAMP,          #实际结束时间
    status               VARCHAR(255),       #片段状态，未开始/进行中/取消/结束/终止
    order_id             INT,                #订单ID
    start_point          INT,                #开始地点
    ending_point         INT,                #结束地点
    executor             INT,                #执行者，即片段任务承担者
    vehicle_id           INT,                #运输工具
    PRIMARY KEY (fragment_id),
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id),
    FOREIGN KEY (start_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (ending_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (executor) REFERENCES User_ (user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle (vehicle_id)
); #运输片段
