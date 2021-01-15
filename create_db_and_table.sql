DROP DATABASE IF EXISTS express;
CREATE DATABASE IF NOT EXISTS express;
USE express;

CREATE TABLE IF NOT EXISTS User_
(
    user_id          BIGINT AUTO_INCREMENT, -- 用户id
    user_name        VARCHAR(255),          -- 用户名
    user_type        CHAR(1),               -- 用户类型，C客户/E雇员/V虚拟用户/S系统用户
    telephone_number VARCHAR(255),          -- 联系方式，暂定为手机号码
    payment          VARCHAR(255),          -- 支付方式，按年/季/月/日/次支付
    PRIMARY KEY (user_id)
); -- 用户


CREATE TABLE IF NOT EXISTS Order_
(
    order_id                  BIGINT AUTO_INCREMENT,              -- 订单编号
    customer_id               BIGINT,                             -- 顾客ID
    status                    VARCHAR(255),                       -- 订单状态，进行中/中断/完成/取消
    create_time               DATETIME DEFAULT CURRENT_TIMESTAMP, -- 订单创建时间
    expect_deliver_time_frame VARCHAR(255),                       -- 期待派送时间段，例如11:00-18:00
    payment                   DOUBLE,                             -- 订单价格
    pay_type                  VARCHAR(255),                       -- 支付类型，预付/到付/记账/免付
    is_paid                   CHAR(1)  DEFAULT 'F',               -- 是否已付款，T/F
    express_type              VARCHAR(255),                       -- 快递类型，当天/明天/后天/普通
    service_type              VARCHAR(255),                       -- 服务类型，即时送|京尊达|冷运|国际
    is_deliver_on_time        CHAR(1)  DEFAULT NULL,              -- 是否按时送达
    weight                    DOUBLE,                             -- 包裹重量
    package_type              VARCHAR(255),                       -- 包装，扁平信封/小盒子/大盒子/大物件
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES User_ (user_id)
); -- 订单

CREATE TABLE IF NOT EXISTS Goods
(
    package_id BIGINT,       -- 包裹ID，即订单ID
    goods_name VARCHAR(255), -- 物品名字
    worth      DOUBLE,       -- 物品价值
    FOREIGN KEY (package_id) REFERENCES Order_ (order_id)
); -- 运输货物

CREATE TABLE IF NOT EXISTS Evaluation
(
    order_id BIGINT,       -- 订单ID
    score    BIGINT,       -- 评分
    content  VARCHAR(255), -- 评价内容
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id)
); -- 订单评价

CREATE TABLE IF NOT EXISTS Vehicle
(
    vehicle_id     BIGINT AUTO_INCREMENT, -- 工具ID，系统内部编号
    type           VARCHAR(255),          -- 工具类型，小电车/面包车/货柜车/火车/飞机/轮船
    brand          VARCHAR(255),          -- 品牌
    license_number VARCHAR(255),          -- 牌号，例如车牌号等社会性质的外部编号
    worth          DOUBLE,                -- 估价
    PRIMARY KEY (vehicle_id)
); -- 运输工具/交通工具

CREATE TABLE IF NOT EXISTS TransferStation
(
    station_id BIGINT AUTO_INCREMENT, -- 结点ID
    nickname   VARCHAR(255),          -- 结点昵称
    location   VARCHAR(255),          -- 结点位置
    type       VARCHAR(255),          -- 结点类型，例如用户主址/用户地址/一级仓库/二级仓库/三级仓库/四级仓库/中转站/断点
    creator    BIGINT,                -- 结点创建者
    manager    BIGINT,                -- 结点管理者
    PRIMARY KEY (station_id),
    FOREIGN KEY (creator) REFERENCES User_ (user_id),
    FOREIGN KEY (manager) REFERENCES User_ (user_id)
); -- 运输结点

CREATE TABLE IF NOT EXISTS TransportFragment
(
    fragment_id          BIGINT AUTO_INCREMENT, -- 片段ID
    road_map             VARCHAR(255),          -- 路线描述
    fragment_description VARCHAR(255),          -- 片段描述
    expected_start_time  DATETIME,              -- 期望开始时间
    actual_start_time    DATETIME,              -- 实际开始时间
    expected_ending_time DATETIME,              -- 期望结束时间
    actual_ending_time   DATETIME,              -- 实际结束时间
    status               VARCHAR(255),          -- 片段状态，未开始/进行中/取消/完成/终止
    order_id             BIGINT,                -- 订单ID
    start_point          BIGINT,                -- 开始地点
    ending_point         BIGINT,                -- 结束地点
    executor             BIGINT,                -- 执行者，即片段任务承担者
    vehicle_id           BIGINT,                -- 运输工具
    PRIMARY KEY (fragment_id),
    FOREIGN KEY (order_id) REFERENCES Order_ (order_id),
    FOREIGN KEY (start_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (ending_point) REFERENCES TransferStation (station_id),
    FOREIGN KEY (executor) REFERENCES User_ (user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle (vehicle_id)
); -- 运输片段


-- 账单1、2、3
-- 账单1:
CREATE VIEW Bill_1 AS
SELECT T1.user_id AS '用户编号', T1.user_name AS '用户名', T1.location AS '用户地址', IFNULL(T2.debt_total, 0) AS '欠款金额'
FROM (SELECT U.user_id, U.user_name, TS.location
      FROM User_ U
               INNER JOIN TransferStation TS ON U.user_id = TS.creator
      WHERE TS.type = '用户主址'
     ) AS T1
         LEFT JOIN (SELECT customer_id, SUM(payment) AS debt_total
                    FROM Order_
                    WHERE is_paid = 'F'
                      AND status NOT IN ('取消')
                      -- AND create_time BETWEEN DATE_SUB('2020-3-1 00:00:00', INTERVAL 1 MONTH) AND '2020-3-1 00:00:00'
                    GROUP BY customer_id) AS T2 ON T1.user_id = T2.customer_id;

-- 账单2
CREATE VIEW Bill_2 AS
SELECT O.customer_id                   AS '用户编号',
       U.user_name                     AS '用户名',
       IFNULL(O.service_type, '无附加服务') AS '服务类型',
       SUM(O.payment)                  AS '总计'
FROM Order_ O
         JOIN User_ U ON O.customer_id = U.user_id
WHERE status NOT IN ('取消')
      -- AND O.create_time BETWEEN DATE_SUB('2020-3-1 00:00:00', INTERVAL 1 MONTH) AND '2020-3-1 00:00:00'
GROUP BY O.customer_id, O.service_type;

-- 账单3
CREATE VIEW Bill_3 AS
SELECT O.customer_id  AS '客户编号',
       U.user_name    AS '客户名',
       O.status       AS '订单状态',
       O.order_id     AS '订单编号',
       T.start_point  AS '发货点编号',
       TS1.nickname   AS '发货点昵称',
       T.ending_point AS '收货点编号',
       TS2.nickname   AS '收货点昵称',
       O.is_paid      AS '是否付款',
       O.payment      AS '收费'
FROM Order_ AS O
         NATURAL JOIN (SELECT order_id, start_point, ending_point
                       FROM (SELECT TF1.order_id, TF1.start_point
                             FROM TransportFragment TF1
                             WHERE TF1.status != '取消'
                               AND TF1.fragment_id = (SELECT TF2.fragment_id
                                                      FROM TransportFragment TF2
                                                      WHERE TF1.order_id = TF2.order_id
                                                        AND TF2.status != '取消'
                                                      ORDER BY TF2.expected_start_time
                                                      LIMIT 0,1)
                            ) AS T1 -- T1表： 订单编号+订单起点
                                NATURAL JOIN (SELECT TF1.order_id, TF1.ending_point
                                              FROM TransportFragment TF1
                                              WHERE TF1.fragment_id = (SELECT TF2.fragment_id
                                                                       FROM TransportFragment TF2
                                                                       WHERE TF1.order_id = TF2.order_id
                                                                       ORDER BY TF2.expected_ending_time DESC
                                                                       LIMIT 0,1)
                       ) AS T2 -- T2表： 订单编号+订单终点
) AS T
         JOIN User_ U ON O.customer_id = U.user_id
         JOIN TransferStation TS1 ON T.start_point = TS1.station_id
         JOIN TransferStation TS2 ON T.ending_point = TS2.station_id
WHERE O.status NOT IN ('取消');
