USE express;

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
                      AND create_time BETWEEN DATE_SUB(FIRST_DATETIME_THIS_MONTH(), INTERVAL 1 MONTH) AND FIRST_DATETIME_THIS_MONTH()
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
  AND O.create_time BETWEEN DATE_SUB(FIRST_DATETIME_THIS_MONTH(), INTERVAL 1 MONTH) AND FIRST_DATETIME_THIS_MONTH()
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
WHERE O.create_time BETWEEN DATE_SUB(FIRST_DATETIME_THIS_MONTH(), INTERVAL 1 MONTH) AND FIRST_DATETIME_THIS_MONTH()
  AND O.status NOT IN ('取消');