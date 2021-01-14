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
WHERE U.user_type = 'V';

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

