/*
 Navicat MySQL Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : countrydb

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 01/03/2021 22:38:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for city
-- ----------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE `city`  (
  `city_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '市id',
  `city_name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市区名称',
  `city_pro_id` int(11) NULL DEFAULT NULL COMMENT '该市对应省id',
  PRIMARY KEY (`city_id`) USING BTREE,
  INDEX `city_ibfk_2`(`city_name`) USING BTREE,
  INDEX `city_pro_id`(`city_pro_id`) USING BTREE,
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`city_pro_id`) REFERENCES `province` (`pro_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of city
-- ----------------------------
INSERT INTO `city` VALUES (101211002, '长沙', NULL);

-- ----------------------------
-- Table structure for district
-- ----------------------------
DROP TABLE IF EXISTS `district`;
CREATE TABLE `district`  (
  `district_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '区id',
  `district_name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '区名称',
  `district_city_id` int(11) NOT NULL COMMENT '该区对应市id',
  PRIMARY KEY (`district_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of district
-- ----------------------------

-- ----------------------------
-- Table structure for people_flow_log
-- ----------------------------
DROP TABLE IF EXISTS `people_flow_log`;
CREATE TABLE `people_flow_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `region_id` int(11) NOT NULL COMMENT '区域id',
  `people_count` int(11) NOT NULL COMMENT '实时人数',
  `curr_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of people_flow_log
-- ----------------------------

-- ----------------------------
-- Table structure for province
-- ----------------------------
DROP TABLE IF EXISTS `province`;
CREATE TABLE `province`  (
  `pro_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '省id',
  `pro_name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '省名称',
  PRIMARY KEY (`pro_id`) USING BTREE,
  INDEX `pro_name`(`pro_name`) USING BTREE,
  CONSTRAINT `province_ibfk_1` FOREIGN KEY (`pro_id`) REFERENCES `city` (`city_pro_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of province
-- ----------------------------

-- ----------------------------
-- Table structure for region_alert_constant
-- ----------------------------
DROP TABLE IF EXISTS `region_alert_constant`;
CREATE TABLE `region_alert_constant`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `region_id` int(11) NOT NULL COMMENT '区域id',
  `people_sparse` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阈值-稀疏',
  `people_commonly` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '一般',
  `people_crowded` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拥挤',
  `people_very_crowded` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '非常拥挤',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of region_alert_constant
-- ----------------------------

-- ----------------------------
-- Table structure for region_management
-- ----------------------------
DROP TABLE IF EXISTS `region_management`;
CREATE TABLE `region_management`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '区域id',
  `region_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '区域名称',
  `region_type` int(11) NOT NULL COMMENT '区域类型',
  `region_latitude_coordinate` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经纬度坐标组',
  `region_central_position` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '中心点位置',
  `region_district_id` int(11) NOT NULL COMMENT '该景区对应的区',
  `region_province_id` int(11) NOT NULL COMMENT '景区对应的省',
  `region_city_id` int(11) NOT NULL COMMENT '景区对应的市',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of region_management
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户',
  `user_account_number` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账号',
  `user_apikey` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Apikey',
  `user_apikey_pwd` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Apikey密码',
  `user_email` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `user_phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '手机号',
  `user_province` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '省',
  `user_city` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '市',
  `user_area` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '区',
  `user_password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `permission_level` int(11) NOT NULL COMMENT '权限级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------

-- ----------------------------
-- Table structure for weather_data_24hours
-- ----------------------------
DROP TABLE IF EXISTS `weather_data_24hours`;
CREATE TABLE `weather_data_24hours`  (
  `date` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `city_name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `week` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hours` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `wea` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tem` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '温度',
  `win` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `win_speed` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `aqi` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`date`, `hours`, `city_name`) USING BTREE,
  INDEX `city_name`(`city_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weather_data_24hours
-- ----------------------------
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '17:00', '多云', '25', '西南风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '18:00', '多云', '21', '南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '19:00', '多云', '21', '南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '20:00', '多云', '21', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '21:00', '多云', '20', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '22:00', '多云', '18', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-21', '长沙', '星期日', '23:00', '多云', '15', '南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '01:00', '多云', '15', '东南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '02/22', '多云', '15', '东南风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '02:00', '多云', '15', '南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '03:00', '多云', '15', '南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '04:00', '多云', '15', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '05:00', '多云', '15', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '06:00', '多云', '15', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '07:00', '多云', '15', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '08:00', '多云', '15', '东南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '09:00', '多云', '15', '东南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '10:00', '多云', '17', '东南风', '1级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '11:00', '多云', '19', '南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '12:00', '多云', '20', '西南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '13:00', '多云', '22', '西南风', '2级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '14:00', '多云', '23', '西南风', '2级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '15:00', '小雨', '23', '南风', '微风', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '16:00', '小雨', '23', '东南风', '微风', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '17:00', '多云', '24', '东风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '18:00', '多云', '23', '东风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '19:00', '多云', '23', '东风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-02-22', '长沙', '星期日', '23:00', '多云', '19', '东南风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-01', '长沙', '星期一', '22:00', '多云', '7', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-01', '长沙', '星期一', '23:00', '多云', '6', '北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '01:00', '晴', '6', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '02:00', '晴', '6', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '03/02', '多云', '6', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '03:00', '晴', '6', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '04:00', '晴', '5', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '05:00', '晴', '5', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '06:00', '晴', '5', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '07:00', '晴', '5', '西北风', '3级', '优');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '08:00', '多云', '5', '西北风', '3级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '09:00', '多云', '6', '西北风', '3级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '10:00', '多云', '8', '北风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '11:00', '多云', '9', '北风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '12:00', '多云', '10', '北风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '13:00', '多云', '11', '东北风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '14:00', '多云', '11', '东北风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '15:00', '多云', '11', '东北风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '16:00', '多云', '11', '东北风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '17:00', '多云', '11', '东风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '18:00', '多云', '11', '东北风', '微风', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '19:00', '多云', '11', '东北风', '2级', '良');
INSERT INTO `weather_data_24hours` VALUES ('2021-03-02', '长沙', '星期一', '20:00', '多云', '10', '东北风', '1级', '良');

-- ----------------------------
-- Table structure for weather_data_7days
-- ----------------------------
DROP TABLE IF EXISTS `weather_data_7days`;
CREATE TABLE `weather_data_7days`  (
  `day` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `city_name` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市名',
  `week` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `wea` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实时天气',
  `wea_day` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '白天天气',
  `tem` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实时温度',
  `tem_max` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最高温度',
  `tem_min` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最低温度',
  `win_day` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `wea_night` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `win_night` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `win_speed` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `air` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '空气指数',
  `air_level` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '空气等级',
  `sunrise` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日出',
  `sunset` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日落',
  PRIMARY KEY (`day`, `date`, `city_name`) USING BTREE,
  INDEX `city_name`(`city_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weather_data_7days
-- ----------------------------
INSERT INTO `weather_data_7days` VALUES ('01日（星期一）', '2021-03-01', '长沙', '星期一', '小雨转多云', '小雨', '9', '9', '5', '西北风', '多云', '无持续风向', '3-4级转<3级', '26', '优', '06:52', '06:52');
INSERT INTO `weather_data_7days` VALUES ('02日（星期二）', '2021-03-02', '长沙', '星期二', '多云转小雨', '多云', '12', '12', '5', '无持续风向', '小雨', '无持续风向', '<3级', '56', '良', '06:51', '06:51');
INSERT INTO `weather_data_7days` VALUES ('03日（星期三）', '2021-03-03', '长沙', '星期三', '小雨', '小雨', '11', '11', '8', '南风', '小雨', '西南风', '<3级', '41', '优', '06:50', '06:50');
INSERT INTO `weather_data_7days` VALUES ('04日（星期四）', '2021-03-04', '长沙', '星期四', '小雨转中雨', '小雨', '15', '15', '9', '南风', '中雨', '东风', '<3级', '26', '优', '06:49', '06:49');
INSERT INTO `weather_data_7days` VALUES ('05日（星期五）', '2021-03-05', '长沙', '星期五', '大雨转小雨', '大雨', '18', '18', '10', '北风', '小雨', '西北风', '<3级', '39', '优', '06:48', '06:48');
INSERT INTO `weather_data_7days` VALUES ('06日（星期六）', '2021-03-06', '长沙', '星期六', '小雨转阴', '小雨', '15', '15', '6', '北风', '阴', '北风', '<3级', '60', '良', '06:47', '06:47');
INSERT INTO `weather_data_7days` VALUES ('07日（星期日）', '2021-03-07', '长沙', '星期日', '阴转小雨', '阴', '11', '11', '6', '北风', '小雨', '西北风', '<3级', '58', '良', '06:46', '06:46');
INSERT INTO `weather_data_7days` VALUES ('21日（星期日）', '2021-02-21', '长沙', '星期日', '多云', '多云', '25', '26', '12', '南风', '多云', '南风', '<3级', '54', '良', '07:00', '07:00');
INSERT INTO `weather_data_7days` VALUES ('22日（星期一）', '2021-02-22', '长沙', '星期一', '小雨', '小雨', '24', '24', '15', '南风', '小雨', '南风', '<3级', '57', '良', '06:59', '06:59');
INSERT INTO `weather_data_7days` VALUES ('23日（星期二）', '2021-02-23', '长沙', '星期二', '多云', '多云', '20', '20', '13', '北风', '多云', '北风', '<3级', '87', '良', '06:58', '06:58');
INSERT INTO `weather_data_7days` VALUES ('24日（星期三）', '2021-02-24', '长沙', '星期三', '小雨', '小雨', '21', '21', '13', '北风', '小雨', '北风', '<3级', '38', '优', '06:57', '06:57');
INSERT INTO `weather_data_7days` VALUES ('25日（星期四）', '2021-02-25', '长沙', '星期四', '小雨', '小雨', '13', '13', '7', '北风', '小雨', '北风', '<3级', '47', '优', '06:56', '06:56');
INSERT INTO `weather_data_7days` VALUES ('26日（星期五）', '2021-02-26', '长沙', '星期五', '小雨', '小雨', '9', '9', '7', '北风', '小雨', '北风', '<3级', '59', '良', '06:55', '06:55');
INSERT INTO `weather_data_7days` VALUES ('27日（星期六）', '2021-02-27', '长沙', '星期六', '小雨', '小雨', '11', '11', '9', '北风', '小雨', '北风', '<3级', '42', '优', '06:54', '06:54');

-- ----------------------------
-- Table structure for weather_data_now
-- ----------------------------
DROP TABLE IF EXISTS `weather_data_now`;
CREATE TABLE `weather_data_now`  (
  `date_now` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `city_name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `update_time` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `week` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '星期',
  `wea` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tem_now` float NULL DEFAULT NULL,
  `tem_max` float NULL DEFAULT NULL,
  `tem_min` float NULL DEFAULT NULL,
  `win` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `win_speed` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `humidity` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pressure` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `air` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `alarm_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `alarm_level` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `alarm_content` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `air_level` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`update_time`, `city_name`) USING BTREE,
  INDEX `city_name`(`city_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weather_data_now
-- ----------------------------
INSERT INTO `weather_data_now` VALUES ('2021-02-20', '长沙', '00:02', NULL, '晴', 14, 24, 10, '南风', '1级', '58%', '1011', '64', '', '', '', '良');
INSERT INTO `weather_data_now` VALUES ('2021-02-21', '长沙', '12:02', '星期日', '晴', 21, 26, 12, '南风', '3级', '44%', '1010', '54', '', '', '', '良');
INSERT INTO `weather_data_now` VALUES ('2021-02-21', '长沙', '13:13', '星期日', '晴', 24, 26, 12, '南风', '2级', '38%', '1009', '57', '', '', '', '良');
INSERT INTO `weather_data_now` VALUES ('2021-02-21', '长沙', '17:41', '星期日', '多云', 25, 26, 12, '南风', '2级', '42%', '1006', '62', '', '', '', '良');
INSERT INTO `weather_data_now` VALUES ('2021-03-01', '长沙', '22:09', '星期一', '多云', 9, 9, 5, '北风', '2级', '77%', '1024', '29', '', '', '', '优');
INSERT INTO `weather_data_now` VALUES ('2021-02-20', '长沙', '23:29', NULL, '晴', 13, 24, 10, '南风', '1级', '62%', '1011', '59', '', '', '', '良');

SET FOREIGN_KEY_CHECKS = 1;
