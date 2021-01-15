-- 跨国大客户，最高开销
INSERT INTO User_ (user_id, user_name, user_type, telephone_number, payment)
VALUES (20000000001, '钱老爹', 'C', '20000000001', 'monthly'),

       (20010000001, '快递员A', 'E', '20010000001', 'monthly'),
       (20010000002, '快递员B', 'E', '20010000002', 'monthly'),
       (20010000003, '快递员C', 'E', '20010000003', 'monthly'),
       (20010000004, '快递员D', 'E', '20010000004', 'monthly'),
       (20010000005, '快递员E', 'E', '20010000005', 'monthly'),

       (20020000001, '钱老娘', 'V', '20020000001', NULL);

INSERT INTO TransferStation (station_id, nickname, location, type, creator, manager)
VALUES (100, '武汉机场', '中国|湖北|武汉｜机场', '中转站', 10086, 10086),
       (101, '东京机场', '日本|东京|机场', '中转站', 10086, 10086),

       (200, '老爹家', '中国|武汉市|东城区|武东1街|yyy', '用户主址', 20000000001, 20000000001),
       (201, '老娘家', '日本|东京|新宿区|yyy', '用户地址', 20000000001, 20020000001);

INSERT INTO Vehicle (vehicle_id, type, brand, license_number, worth)
VALUES (10001, '小电车', '小刀', 'xdc10001', 1500.0),
       (10002, '面包车', '五菱', 'mbc10002', 50000.0),
       (10003, '飞机', '波音', '飞机10003', 50000000000.0),
       (10004, '面包车', '本田', 'mbc10004', 100000.0),
       (10005, '小电车', '特斯拉', 'xdc10005', 10000.0);

INSERT INTO Order_ (order_id, customer_id, status, create_time, expect_deliver_time_frame, payment, pay_type, is_paid,
                    express_type, service_type, is_deliver_on_time, weight, package_type)
VALUES (100, 20000000001, '完成', CONCAT(LAST_YEAR_MONTH(1), '-15 8:00:00'), '上午', 666.66, '记账', 'F', '明天',
        '即时送|京尊达|冷运|国际', 'T', 11.1, '小盒子');

INSERT INTO Goods (package_id, goods_name, worth)
VALUES (100, '冰雕戒指', 66666.66);

INSERT INTO TransportFragment (fragment_id, road_map, fragment_description, expected_start_time, actual_start_time,
                               expected_ending_time, actual_ending_time, status, order_id, start_point, ending_point,
                               executor, vehicle_id)
VALUES (101, NULL, '直达机场', CONCAT(LAST_YEAR_MONTH(1), '-15 9:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-15 9:00:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-15 10:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-15 10:00:00'),
        '完成', 100, 200, 100, 20010000002, 10002),
       (102, NULL, 'flying', CONCAT(LAST_YEAR_MONTH(1), '-15 11:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-15 11:00:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-16 9:30:00'), CONCAT(LAST_YEAR_MONTH(1), '-16 9:30:00'),
        '完成', 100, 100, 101, 20010000003, 10003),
       (103, NULL, '立刻配送', CONCAT(LAST_YEAR_MONTH(1), '-16 10:00:00'), CONCAT(LAST_YEAR_MONTH(1), '-16 9:45:00'),
        CONCAT(LAST_YEAR_MONTH(1), '-16 10:30:00'), CONCAT(LAST_YEAR_MONTH(1), '-16 10:30:00'),
        '完成', 100, 101, 201, 20010000004, 10004);