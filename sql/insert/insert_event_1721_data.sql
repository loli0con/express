USE express;

-- 卡车1721被毁事件，暨"两个幸运儿给自己心仪的妹子寄情书事件"
INSERT INTO User_ (user_id, user_name, user_type, telephone_number, payment)
VALUES (10000000001, '倒霉蛋1', 'C', '10000000001', 'once'),    -- 一位幸运儿
       (10000000002, '倒霉蛋2', 'C', '10000000002', 'once'),    -- 另一位幸运儿

       (10010000001, '妹子1', 'V', '10010000001', NULL),       -- 心仪的妹子
       (10010000002, '妹子2', 'V', '10010000002', NULL),       -- 心仪的妹子

       (10020000001, '快递员1', 'E', '10020000001', 'monthly'), -- 深东1街的快递小哥
       (10020000002, '快递员2', 'E', '10020000002', 'monthly'), -- 1721的倒霉司机
       (10020000003, '快递员3', 'E', '10020000003', 'monthly'), -- 深西1街的快递小哥

       (10000000003, '幸存的发货人', 'C', '10000000003', 'once'),  -- 最后一次成功交货的发货人
       (10010000003, '幸存的收货人1', 'V', '10010000003', NULL),   -- 最后一次成功交货的收获人1
       (10010000004, '幸存的收货人2', 'V', '10010000003', NULL); -- 最后一次成功交货的收获人2

INSERT INTO Vehicle (vehicle_id, type, brand, license_number, worth)
VALUES (1, '小电车', '雅迪', 'xdc1', 1000), -- 深东1街的快递小哥的车车
       (2, '小电车', '爱玛', 'xdc2', 1000), -- 深西1街的快递小哥的车车
       (1721, '货车', '倒霉牌', 'hc1721', 50000); -- 罪魁祸首1721卡车

INSERT INTO TransferStation (station_id, nickname, location, type, creator, manager)
VALUES (12, '倒霉蛋1的家', '中国|深圳市|东城区|深东1街|xxx', '用户主址', 10000000001, 10000000001), -- 发货地址1
       (13, '妹子1的家', '中国|深圳市|西城区|深西1街|xxx', '用户地址', 10000000001, 10010000001),  -- 收获地址1
       (14, '倒霉蛋2的家', '中国|深圳市|东城区|深东1街|xxx', '用户主址', 10000000002, 10000000002), -- 发货地址2
       (15, '妹子2的家', '中国|深圳市|西城区|深西1街|xxx', '用户地址', 10000000002, 10010000002),  -- 收货地址2

       (16, '幸存的发货人的家', '中国|深圳市|东城区|深东1街|xxx', '用户主址', 10000000003, 10000000003),
       (17, '幸存的收货人1的家', '中国|深圳市|西城区|深西1街|xxx', '用户地址', 10000000003, 10010000003),
       (18, '幸存的收货人2的家', '中国|深圳市|西城区|深西1街|xxx', '用户地址', 10000000003, 10010000004);

INSERT INTO Order_ (order_id, customer_id, status, create_time, expect_deliver_time_frame, payment, pay_type, is_paid,
                    express_type, service_type, is_deliver_on_time, weight, package_type)
VALUES (1, 10000000001, '中断', CONCAT(LAST_YEAR_MONTH(1), '-2 8:00:00'), '晚上', 5.0, '预付', 'T', '当天', '即时送',
        NULL, 1.1, '扁平信封'),
       (2, 10000000002, '中断', CONCAT(LAST_YEAR_MONTH(1), '-2 9:00:00'), '晚上', 5.0, '预付', 'T', '当天', '即时送', NULL, 1.1,
        '扁平信封'),
       (3, 10000000003, '完成', CONCAT(LAST_YEAR_MONTH(2), '-30 8:00:00'), '晚上', 10.0, '到付', 'T', '当天', '京尊达', 'T', 1.1,
        '小盒子'),
       (4, 10000000003, '完成', CONCAT(LAST_YEAR_MONTH(2), '-30 8:00:00'), '晚上', 12.0, '到付', 'T', '当天', NULL, 'F', 2.2,
        '大盒子');

INSERT
INTO Goods (package_id, goods_name, worth)
VALUES (1, '倒霉蛋1的情书', 1.1), -- 情书1
       (2, '倒霉蛋2的情书', 1.2), -- 情书2

       (3, '水晶球', 10.1),
       (4, '小米充电器', 8.8),
       (4, '华为充电器', 9.9);

INSERT INTO TransportFragment (fragment_id, road_map, fragment_description, expected_start_time, actual_start_time,
                               expected_ending_time, actual_ending_time, status, order_id, start_point, ending_point,
                               executor, vehicle_id)
VALUES (1, '模拟线路1', '上门取件', CONCAT(LAST_YEAR_MONTH(1), '-2 8:15:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 8:15:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-2 8:30:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 8:30:00'), '完成', 1,
        12, 8, 10020000001, 1),
       (2, '模拟线路2', '从深东1街分站 直接送往 深西1街分站', CONCAT(LAST_YEAR_MONTH(1), '-2 11:00:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-2 11:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 14:00:00'), NULL, '终止',
        1, 8, 9, 10020000002, 1721),
       (3, '模拟线路3', '深西1街分站 送往 妹子1家里', CONCAT(LAST_YEAR_MONTH(1), '-2 16:00:00'), NULL,
        CONCAT(LAST_YEAR_MONTH(1), '-2 20:00:00'), NULL, '取消', 1, 9, 13,
        10020000003, 2),
       (4, '模拟线路4', '上门取件', CONCAT(LAST_YEAR_MONTH(1), '-2 9:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 9:00:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-2 9:15:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 9:15:00'), '完成', 2, 14,
        8, 10020000001, 1),
       (5, '模拟线路5', '从深东1街分站 直接送往 深西1街分站', CONCAT(LAST_YEAR_MONTH(1), '-2 11:00:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-2 11:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-2 14:00:00'), NULL,
        '终止', 2, 8, 9, 10020000002, 1721),
       (6, '模拟线路6', '深西1街分站 送往 妹子2家里', CONCAT(LAST_YEAR_MONTH(1), '-2 16:00:00'), NULL,
        CONCAT(LAST_YEAR_MONTH(1), '-2 20:30:00'), NULL, '取消', 2, 9, 15,
        10020000003, 2),

       (7, '模拟线路7', '上门取件', CONCAT(LAST_YEAR_MONTH(2), '-30 9:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 9:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 9:30:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 9:30:00'),
        '完成', 3, 16, 8, 10020000001, 1),
       (8, '模拟线路8', '从深东1街分站 直接送往 深西1街分站', CONCAT(LAST_YEAR_MONTH(2), '-30 10:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 10:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 15:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 15:00:00'), '完成', 3, 8, 9, 10020000002, 1721),
       (9, '模拟线路9', '从深西1街分站 送往 幸存的收货人1的家', CONCAT(LAST_YEAR_MONTH(2), '-30 18:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 18:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 19:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 19:00:00'), '完成', 3, 9, 17, 10020000003, 2),
       (10, '模拟线路10', '上门取件', CONCAT(LAST_YEAR_MONTH(2), '-30 9:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 9:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 9:30:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 9:30:00'),
        '完成', 4, 16, 8, 10020000001, 1),
       (11, '模拟线路11', '从深东1街分站 直接送往 深西1街分站', CONCAT(LAST_YEAR_MONTH(2), '-30 10:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 10:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 15:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 15:00:00'), '完成', 4, 8, 9, 10020000002, 1721),
       (12, '模拟线路12', '从深西1街分站 送往 幸存的收货人2的家', CONCAT(LAST_YEAR_MONTH(2), '-30 18:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 18:00:00'), CONCAT(LAST_YEAR_MONTH(2), '-30 20:00:00'),
        CONCAT(LAST_YEAR_MONTH(2), '-30 20:10:00'), '完成', 4, 9, 18, 10020000003, 2);