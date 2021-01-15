-- 由于测试数据的日期时间是固定的不变的，所以如果我查询"上个月"的账单，那么肯定是不行的
-- 因为"上个月"是基于现在的时间来说的，但是现在的时间是流动的，不是静止的，所以会偏移测试数据
-- 请仔细查看Order_表中的测试数据
-- 在这里，我假定现在的时间是2020年的3月份，查看的账单对应的是2020年的2月份的
-- WHERE O.create_time BETWEEN DATE_SUB('2020-3-1 00:00:00', INTERVAL 1 MONTH) AND '2020-3-1 00:00:00'
-- 上述的sql语句在视图中存在，'2020-3-1 00:00:00' 实际被替换为 DATE_ADD(CURDATE(), INTERVAL -DAY(CURDATE()) + 1 DAY)

SELECT *
FROM Bill_1;

SELECT *
FROM Bill_2;

SELECT *
FROM Bill_3;