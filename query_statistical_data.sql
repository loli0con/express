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