DROP DATABASE IF EXISTS express;
CREATE DATABASE IF NOT EXISTS express;
USE express;

CREATE TABLE IF NOT EXISTS UserGroup(  # 员工工作组
# 不太理解员工的数据模型，涉及权限分配，不知道该如何定义
group_id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS User_(  # 用户
user_id INT AUTO_INCREMENT,
user_type CHAR(1),
telephone_number VARCHAR(255),
payment varchar(255),
PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS Identity(  # 员工身份
user_id INT,
group_id INT,
is_leader CHAR(1),
FOREIGN KEY(user_id) REFERENCES User_(user_id),
FOREIGN KEY(group_id) REFERENCES UserGroup(group_id)
);

CREATE TABLE IF NOT EXISTS Order_(  # 订单
order_id INT AUTO_INCREMENT,
customer_id INT,
create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
is_paid CHAR(1) DEFAULT 'F',
is_deliver_on_time CHAR(1) DEFAULT NULL,
###virtual_table_package###
package_type VARCHAR(255),
weight DOUBLE,
###virtual_table_package###
PRIMARY KEY(order_id),
FOREIGN KEY(customer_id) REFERENCES User_(user_id)
);

CREATE TABLE IF NOT EXISTS Goods(  # 运输货物
package_id INT,
goods_name VARCHAR(255),
worth DOUBLE,
FOREIGN KEY(package_id) REFERENCES Order_(order_id)
);

CREATE TABLE IF NOT EXISTS Evaluation(  # 订单评价
order_id INT,
score INT,
content VARCHAR(255),
FOREIGN KEY(order_id) REFERENCES Order_(order_id)
);

CREATE TABLE IF NOT EXISTS Vehicle(  # 运输工具/交通工具
vehicle_id INT AUTO_INCREMENT,
type VARCHAR(255),
brand VARCHAR(255),
worth DOUBLE,
PRIMARY KEY(vehicle_id)
);

CREATE TABLE IF NOT EXISTS TransferStation(  # 运输结点
station_id INT AUTO_INCREMENT,
nickname VARCHAR(255),
location VARCHAR(255),
type VARCHAR(255),
manager INT,
PRIMARY KEY(station_id),
FOREIGN KEY(manager) REFERENCES User_(user_id)
);

CREATE TABLE IF NOT EXISTS TransportFragment(  # 运输片段
fragment_id INT AUTO_INCREMENT,
order_id INT,
expected_start_time DATETIME,
actual_start_time DATETIME,
expected_ending_time DATETIME,
actual_ending_time DATETIME,
road_map VARCHAR(255),
start_point INT,
ending_point INT,
executor INT,
PRIMARY KEY(fragment_id),
FOREIGN KEY(order_id) REFERENCES Order_(order_id),
FOREIGN KEY(start_point) REFERENCES TransferStation(station_id),
FOREIGN KEY(ending_point) REFERENCES TransferStation(station_id),
FOREIGN KEY(executor) REFERENCES User_(user_id)
);

