USE express;

CREATE TABLE IF NOT EXISTS User_
(
    user_id          BIGINT AUTO_INCREMENT COMMENT '用户编号',
    user_name        VARCHAR(255) COMMENT '用户名',
    user_type        CHAR(1) COMMENT '用户类型，C客户/E雇员/V虚拟用户/S系统用户',
    telephone_number VARCHAR(255) COMMENT '联系方式，暂定为手机号码',
    payment          VARCHAR(255) COMMENT '支付方式，按 年/季/月/日/次 支付',
    PRIMARY KEY (user_id)
) COMMENT ='用户';


CREATE TABLE IF NOT EXISTS Order_
(
    order_id                  BIGINT AUTO_INCREMENT COMMENT '订单编号',
    customer_id               BIGINT COMMENT '顾客编号',
    status                    VARCHAR(255) COMMENT '订单状态，进行中/中断/完成/取消',
    create_time               DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '订单创建时间',
    expect_deliver_time_frame VARCHAR(255) COMMENT '期待派送时间段，早上/下午/晚上',
    payment                   DOUBLE COMMENT '订单价格',
    pay_type                  VARCHAR(255) COMMENT '支付类型，预付/到付/记账/免付',
    is_paid                   CHAR(1)  DEFAULT 'F' COMMENT '是否已付款，T/F',
    express_type              VARCHAR(255) COMMENT '快递类型，当天/明天/后天/普通',
    service_type              VARCHAR(255) COMMENT '服务类型，即时送|京尊达|冷运|国际',
    is_deliver_on_time        CHAR(1)  DEFAULT NULL COMMENT '是否按时送达',
    weight                    DOUBLE COMMENT '包裹重量',
    package_type              VARCHAR(255) COMMENT '包装，扁平信封/小盒子/大盒子/大物件',
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES User_ (user_id)
) COMMENT ='订单';

CREATE TABLE IF NOT EXISTS Goods
(
    package_id BIGINT COMMENT '包裹编号，即订单编号',
    goods_name VARCHAR(255) COMMENT '物品名字',
    worth      DOUBLE COMMENT '物品价值',
    FOREIGN KEY (package_id) REFERENCES Order_ (order_id)
) COMMENT ='运输货物';

CREATE TABLE IF NOT EXISTS Evaluation
(
    order_id BIGINT COMMENT '订单编号',
    score    BIGINT COMMENT '评分',
    content  VARCHAR(255) COMMENT '评价内容',
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id)
) COMMENT ='订单评价';

CREATE TABLE IF NOT EXISTS Vehicle
(
    vehicle_id     BIGINT AUTO_INCREMENT COMMENT '工具编号，系统内部编号',
    type           VARCHAR(255) COMMENT '工具类型，小电车/面包车/货柜车/火车/飞机/轮船',
    brand          VARCHAR(255) COMMENT '品牌',
    license_number VARCHAR(255) COMMENT '牌号，例如车牌号等社会性质的外部编号',
    worth          DOUBLE COMMENT '估价',
    PRIMARY KEY (vehicle_id)
) COMMENT ='运输工具/交通工具';

CREATE TABLE IF NOT EXISTS TransferStation
(
    station_id BIGINT AUTO_INCREMENT COMMENT '结点编号',
    nickname   VARCHAR(255) COMMENT '结点昵称',
    location   VARCHAR(255) COMMENT '结点位置',
    type       VARCHAR(255) COMMENT '结点类型，例如用户主址/用户地址/一级仓库/二级仓库/三级仓库/四级仓库/中转站/断点',
    creator    BIGINT COMMENT '结点创建者',
    manager    BIGINT COMMENT '结点管理者/联络人',
    PRIMARY KEY (station_id),
    FOREIGN KEY (creator) REFERENCES User_ (user_id),
    FOREIGN KEY (manager) REFERENCES User_ (user_id)
) COMMENT ='运输结点';

CREATE TABLE IF NOT EXISTS TransportFragment
(
    fragment_id          BIGINT AUTO_INCREMENT COMMENT '片段编号',
    road_map             VARCHAR(255) COMMENT '路线描述',
    fragment_description VARCHAR(255) COMMENT '片段描述',
    expected_start_time  DATETIME COMMENT '期望开始时间',
    actual_start_time    DATETIME COMMENT '实际开始时间',
    expected_ending_time DATETIME COMMENT '期望结束时间',
    actual_ending_time   DATETIME COMMENT '实际结束时间',
    status               VARCHAR(255) COMMENT '片段状态，未开始/进行中/取消/完成/终止',
    order_id             BIGINT COMMENT '订单编号',
    start_point          BIGINT COMMENT '开始地点',
    ending_point         BIGINT COMMENT '结束地点',
    executor             BIGINT COMMENT '执行者，即片段任务承担者/责任人',
    vehicle_id           BIGINT COMMENT '运输工具',
    PRIMARY KEY (fragment_id),
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id),
    FOREIGN KEY (start_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (ending_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (executor) REFERENCES User_ (user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle (vehicle_id)
) COMMENT ='运输片段';

