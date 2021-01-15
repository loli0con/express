-- 查询1721卡车被摧毁时对应的运输片段
SELECT T.order_id
FROM TransportFragment T
WHERE vehicle_id = 1721
  AND T.status = '终止';

-- 找到车祸发生时卡车上有包裹的所有顾客
SELECT customer_id
FROM Order_
WHERE order_id IN (SELECT T.order_id
                   FROM TransportFragment T
                   WHERE vehicle_id = 1721
                     AND T.status = '终止'
);

-- 找到车祸发生时卡车上有包裹的所有收件人
SELECT U.*
FROM TransportFragment TF
         JOIN TransferStation TS ON TF.ending_point = TS.station_id
         JOIN User_ U ON TS.manager = U.user_id
WHERE U.user_type = 'V'
  AND TF.order_id IN (SELECT T.order_id
                      FROM TransportFragment T
                      WHERE vehicle_id = 1721
                        AND T.status = '终止'
);

-- 找到车祸前那辆卡车最后一次成功交货 (交货记录：完成两个运输结点的转流)
SELECT *
FROM TransportFragment T3
WHERE T3.actual_ending_time = (SELECT MAX(T2.actual_ending_time)
                               FROM TransportFragment T2
                               WHERE T2.actual_ending_time <= (SELECT MIN(T1.expected_ending_time)
                                                               FROM TransportFragment T1
                                                               WHERE vehicle_id = 1721
                                                                 AND T1.status = '终止'
                               )
                                 AND vehicle_id = 1721
                                 AND T2.status = '完成')
  AND T3.status = '完成'
  AND T3.vehicle_id = 1721;

-- 找到在过去一年中运送包裹最多的客户(请注意，由于测试数据是死的，所以该查询会在2021-1-30 8:00:00之后返回空结果)
SELECT O.customer_id, COUNT(1) AS '订单数量'
FROM Order_ O
WHERE O.create_time BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW()
GROUP BY O.customer_id
ORDER BY COUNT(1) DESC
LIMIT 0,1;

-- 找到在过去一年中运送包裹最多的客户
-- 请注意，由于测试数据是死的，请确保NOW函数返回的时间范围在2020-1-30 8:00:00 到 2021-1-30 8:00:00 之间
SELECT O.customer_id, COUNT(1) AS '订单数量'
FROM Order_ O
WHERE O.create_time BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW()
GROUP BY O.customer_id
ORDER BY COUNT(1) DESC
LIMIT 0,1;

-- 找到在过去一年中运送包裹最多的客户
-- 该查询假定当前datetime为2021-1-1 00:00:00
SELECT O.customer_id, COUNT(1) AS '订单数量'
FROM Order_ O
WHERE O.create_time BETWEEN DATE_SUB('2021-1-1 00:00:00', INTERVAL 1 YEAR) AND '2021-1-1 00:00:00'
GROUP BY O.customer_id
ORDER BY COUNT(1) DESC
LIMIT 0,1;

-- 找到在过去一年中花费最多的客户
-- 请注意，由于测试数据是死的，请确保NOW函数返回的时间范围在2020-1-30 8:00:00 到 2021-1-30 8:00:00 之间
SELECT O.customer_id, SUM(O.payment) AS '花费总额'
FROM Order_ O
WHERE O.create_time BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW()
GROUP BY O.customer_id
ORDER BY SUM(O.payment) DESC
LIMIT 0,1;

-- 找到在过去一年中花费最多的客户
-- 该查询假定当前datetime为2021-1-1 00:00:00
SELECT O.customer_id, SUM(O.payment) AS '花费总额'
FROM Order_ O
WHERE O.create_time BETWEEN DATE_SUB('2021-1-1 00:00:00', INTERVAL 1 YEAR) AND '2021-1-1 00:00:00'
GROUP BY O.customer_id
ORDER BY SUM(O.payment) DESC
LIMIT 0,1;

-- 顾客最多的街道
SELECT LEFT(TS.location, INSTR(TS.location, '街')) AS '顾客最多的街道'
FROM TransferStation TS
WHERE TS.type = '用户主址'
GROUP BY LEFT(TS.location, INSTR(TS.location, '街'))
ORDER BY COUNT(1) DESC
LIMIT 0,1;

-- 查找未在承诺时间内交付的包裹
SELECT *
FROM Order_
WHERE is_deliver_on_time = 'F';

-- 上个月的账单1    一张简单的账单：客户、地址和欠款。
-- 用户+地址
SELECT U.user_id, U.user_name, TS.location
FROM User_ U
         INNER JOIN TransferStation TS ON U.user_id = TS.creator
WHERE TS.type = '用户主址';

-- 用户+欠款 ,假设现在是2020年3月
SELECT customer_id, SUM(payment) AS debt_total
FROM Order_
WHERE is_paid = 'F'
  AND create_time BETWEEN DATE_SUB('2020-3-1 00:00:00', INTERVAL 1 MONTH) AND '2020-3-1 00:00:00'
GROUP BY customer_id;

-- 用户+地址+欠款
SELECT T1.user_id, T1.user_name, T1.location, IFNULL(T2.debt_total, 0) AS 欠款
FROM (SELECT U.user_id, U.user_name, TS.location
      FROM User_ U
               INNER JOIN TransferStation TS ON U.user_id = TS.creator
      WHERE TS.type = '用户主址'
     ) AS T1
         LEFT JOIN (SELECT customer_id, SUM(payment) AS debt_total
                    FROM Order_
                    WHERE is_paid = 'F'
                      AND create_time BETWEEN DATE_SUB('2020-3-1 00:00:00', INTERVAL 1 MONTH) AND '2020-3-1 00:00:00'
                    GROUP BY customer_id) AS T2 ON T1.user_id = T2.customer_id;

-- 上个月的账单2    按服务类型列出费用的账单
SELECT customer_id, IFNULL(service_type, '无附加服务'), SUM(payment)
FROM Order_
GROUP BY customer_id, service_type;