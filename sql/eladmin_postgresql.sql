/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : PostgreSQL
 Source Schema         : eladmin-mp

 File Encoding         : UTF8

 Date: 19/06/2025 16:56:01
*/

-- SET client_encoding = 'UTF8';

-- ----------------------------
-- Table structure for code_column
-- ----------------------------
DROP TABLE IF EXISTS code_column;
CREATE TABLE code_column (
  column_id BIGSERIAL PRIMARY KEY,
  table_name VARCHAR(180) DEFAULT NULL,
  column_name VARCHAR(255) DEFAULT NULL,
  column_type VARCHAR(255) DEFAULT NULL,
  dict_name VARCHAR(255) DEFAULT NULL,
  extra VARCHAR(255) DEFAULT NULL,
  form_show BOOLEAN DEFAULT NULL,
  form_type VARCHAR(255) DEFAULT NULL,
  key_type VARCHAR(255) DEFAULT NULL,
  list_show BOOLEAN DEFAULT NULL,
  not_null BOOLEAN DEFAULT NULL,
  query_type VARCHAR(255) DEFAULT NULL,
  remark VARCHAR(255) DEFAULT NULL
);
CREATE INDEX idx_table_name ON code_column(table_name);
COMMENT ON TABLE code_column IS '代码生成字段信息存储';
COMMENT ON COLUMN code_column.column_id IS 'ID';
COMMENT ON COLUMN code_column.table_name IS '表名';
COMMENT ON COLUMN code_column.column_name IS '数据库字段名称';
COMMENT ON COLUMN code_column.column_type IS '数据库字段类型';
COMMENT ON COLUMN code_column.dict_name IS '字典名称';
COMMENT ON COLUMN code_column.extra IS '字段额外的参数';
COMMENT ON COLUMN code_column.form_show IS '是否表单显示';
COMMENT ON COLUMN code_column.form_type IS '表单类型';
COMMENT ON COLUMN code_column.key_type IS '数据库字段键类型';
COMMENT ON COLUMN code_column.list_show IS '是否在列表显示';
COMMENT ON COLUMN code_column.not_null IS '是否为空';
COMMENT ON COLUMN code_column.query_type IS '查询类型';
COMMENT ON COLUMN code_column.remark IS '描述';

-- ----------------------------
-- Records of code_column
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for code_config
-- ----------------------------
DROP TABLE IF EXISTS code_config;
CREATE TABLE code_config (
  config_id BIGSERIAL PRIMARY KEY,
  table_name VARCHAR(255) DEFAULT NULL,
  author VARCHAR(255) DEFAULT NULL,
  cover BOOLEAN DEFAULT NULL,
  module_name VARCHAR(255) DEFAULT NULL,
  pack VARCHAR(255) DEFAULT NULL,
  path VARCHAR(255) DEFAULT NULL,
  api_path VARCHAR(255) DEFAULT NULL,
  prefix VARCHAR(255) DEFAULT NULL,
  api_alias VARCHAR(255) DEFAULT NULL
);
CREATE INDEX idx_table_name ON code_config(table_name);
COMMENT ON TABLE code_config IS '代码生成器配置';
COMMENT ON COLUMN code_config.config_id IS 'ID';
COMMENT ON COLUMN code_config.table_name IS '表名';
COMMENT ON COLUMN code_config.author IS '作者';
COMMENT ON COLUMN code_config.cover IS '是否覆盖';
COMMENT ON COLUMN code_config.module_name IS '模块名称';
COMMENT ON COLUMN code_config.pack IS '至于哪个包下';
COMMENT ON COLUMN code_config.path IS '前端代码生成的路径';
COMMENT ON COLUMN code_config.api_path IS '前端Api文件路径';
COMMENT ON COLUMN code_config.prefix IS '表前缀';
COMMENT ON COLUMN code_config.api_alias IS '接口名称';

-- ----------------------------
-- Records of code_config
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_app
-- ----------------------------
DROP TABLE IF EXISTS mnt_app;
CREATE TABLE mnt_app (
  app_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  upload_path VARCHAR(255) DEFAULT NULL,
  deploy_path VARCHAR(255) DEFAULT NULL,
  backup_path VARCHAR(255) DEFAULT NULL,
  port INTEGER DEFAULT NULL,
  start_script VARCHAR(4000) DEFAULT NULL,
  deploy_script VARCHAR(4000) DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE mnt_app IS '应用管理';
COMMENT ON COLUMN mnt_app.app_id IS 'ID';
COMMENT ON COLUMN mnt_app.name IS '应用名称';
COMMENT ON COLUMN mnt_app.upload_path IS '上传目录';
COMMENT ON COLUMN mnt_app.deploy_path IS '部署路径';
COMMENT ON COLUMN mnt_app.backup_path IS '备份路径';
COMMENT ON COLUMN mnt_app.port IS '应用端口';
COMMENT ON COLUMN mnt_app.start_script IS '启动脚本';
COMMENT ON COLUMN mnt_app.deploy_script IS '部署脚本';
COMMENT ON COLUMN mnt_app.create_by IS '创建者';
COMMENT ON COLUMN mnt_app.update_by IS '更新者';
COMMENT ON COLUMN mnt_app.create_time IS '创建日期';
COMMENT ON COLUMN mnt_app.update_time IS '更新时间';

-- ----------------------------
-- Records of mnt_app
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_database
-- ----------------------------
DROP TABLE IF EXISTS mnt_database;
CREATE TABLE mnt_database (
  db_id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  jdbc_url VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  pwd VARCHAR(255) NOT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE mnt_database IS '数据库管理';
COMMENT ON COLUMN mnt_database.db_id IS 'ID';
COMMENT ON COLUMN mnt_database.name IS '名称';
COMMENT ON COLUMN mnt_database.jdbc_url IS 'jdbc连接';
COMMENT ON COLUMN mnt_database.user_name IS '账号';
COMMENT ON COLUMN mnt_database.pwd IS '密码';
COMMENT ON COLUMN mnt_database.create_by IS '创建者';
COMMENT ON COLUMN mnt_database.update_by IS '更新者';
COMMENT ON COLUMN mnt_database.create_time IS '创建时间';
COMMENT ON COLUMN mnt_database.update_time IS '更新时间';

-- ----------------------------
-- Records of mnt_database
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_deploy
-- ----------------------------
DROP TABLE IF EXISTS mnt_deploy;
CREATE TABLE mnt_deploy (
  deploy_id BIGSERIAL PRIMARY KEY,
  app_id BIGINT DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_app_id ON mnt_deploy(app_id);
COMMENT ON TABLE mnt_deploy IS '部署管理';
COMMENT ON COLUMN mnt_deploy.deploy_id IS 'ID';
COMMENT ON COLUMN mnt_deploy.app_id IS '应用编号';
COMMENT ON COLUMN mnt_deploy.create_by IS '创建者';
COMMENT ON COLUMN mnt_deploy.update_by IS '更新者';
COMMENT ON COLUMN mnt_deploy.update_time IS '更新时间';

-- ----------------------------
-- Records of mnt_deploy
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_deploy_history
-- ----------------------------
DROP TABLE IF EXISTS mnt_deploy_history;
CREATE TABLE mnt_deploy_history (
  history_id VARCHAR(50) PRIMARY KEY,
  app_name VARCHAR(255) NOT NULL,
  deploy_date TIMESTAMP NOT NULL,
  deploy_user VARCHAR(50) NOT NULL,
  ip VARCHAR(20) NOT NULL,
  deploy_id BIGINT DEFAULT NULL
);
COMMENT ON TABLE mnt_deploy_history IS '部署历史管理';
COMMENT ON COLUMN mnt_deploy_history.history_id IS 'ID';
COMMENT ON COLUMN mnt_deploy_history.app_name IS '应用名称';
COMMENT ON COLUMN mnt_deploy_history.deploy_date IS '部署日期';
COMMENT ON COLUMN mnt_deploy_history.deploy_user IS '部署用户';
COMMENT ON COLUMN mnt_deploy_history.ip IS '服务器IP';
COMMENT ON COLUMN mnt_deploy_history.deploy_id IS '部署编号';

-- ----------------------------
-- Records of mnt_deploy_history
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_deploy_server
-- ----------------------------
DROP TABLE IF EXISTS mnt_deploy_server;
CREATE TABLE mnt_deploy_server (
  deploy_id BIGINT NOT NULL,
  server_id BIGINT NOT NULL,
  PRIMARY KEY (deploy_id, server_id)
);
CREATE INDEX idx_deploy_id ON mnt_deploy_server(deploy_id);
CREATE INDEX idx_server_id ON mnt_deploy_server(server_id);
COMMENT ON TABLE mnt_deploy_server IS '应用与服务器关联';
COMMENT ON COLUMN mnt_deploy_server.deploy_id IS '部署ID';
COMMENT ON COLUMN mnt_deploy_server.server_id IS '服务ID';

-- ----------------------------
-- Records of mnt_deploy_server
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mnt_server
-- ----------------------------
DROP TABLE IF EXISTS mnt_server;
CREATE TABLE mnt_server (
  server_id BIGSERIAL PRIMARY KEY,
  account VARCHAR(50) DEFAULT NULL,
  ip VARCHAR(20) DEFAULT NULL,
  name VARCHAR(100) DEFAULT NULL,
  password VARCHAR(100) DEFAULT NULL,
  port INTEGER DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_ip ON mnt_server(ip);
COMMENT ON TABLE mnt_server IS '服务器管理';
COMMENT ON COLUMN mnt_server.server_id IS 'ID';
COMMENT ON COLUMN mnt_server.account IS '账号';
COMMENT ON COLUMN mnt_server.ip IS 'IP地址';
COMMENT ON COLUMN mnt_server.name IS '名称';
COMMENT ON COLUMN mnt_server.password IS '密码';
COMMENT ON COLUMN mnt_server.port IS '端口';
COMMENT ON COLUMN mnt_server.create_by IS '创建者';
COMMENT ON COLUMN mnt_server.update_by IS '更新者';
COMMENT ON COLUMN mnt_server.create_time IS '创建时间';
COMMENT ON COLUMN mnt_server.update_time IS '更新时间';

-- ----------------------------
-- Records of mnt_server
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS sys_dept;
CREATE TABLE sys_dept (
  dept_id BIGSERIAL PRIMARY KEY,
  pid BIGINT DEFAULT NULL,
  sub_count INTEGER DEFAULT 0,
  name VARCHAR(255) NOT NULL,
  dept_sort INTEGER DEFAULT 999,
  enabled BOOLEAN NOT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_pid ON sys_dept(pid);
CREATE INDEX idx_enabled ON sys_dept(enabled);
COMMENT ON TABLE sys_dept IS '部门';
COMMENT ON COLUMN sys_dept.dept_id IS 'ID';
COMMENT ON COLUMN sys_dept.pid IS '上级部门';
COMMENT ON COLUMN sys_dept.sub_count IS '子部门数目';
COMMENT ON COLUMN sys_dept.name IS '名称';
COMMENT ON COLUMN sys_dept.dept_sort IS '排序';
COMMENT ON COLUMN sys_dept.enabled IS '状态';
COMMENT ON COLUMN sys_dept.create_by IS '创建者';
COMMENT ON COLUMN sys_dept.update_by IS '更新者';
COMMENT ON COLUMN sys_dept.create_time IS '创建日期';
COMMENT ON COLUMN sys_dept.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (2, 7, 1, '研发部', 3, TRUE, 'admin', 'admin', '2019-03-25 09:15:32', '2020-08-02 14:48:47');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (5, 7, 0, '运维部', 4, TRUE, 'admin', 'admin', '2019-03-25 09:20:44', '2020-05-17 14:27:27');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (6, 8, 0, '测试部', 6, TRUE, 'admin', 'admin', '2019-03-25 09:52:18', '2020-06-08 11:59:21');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (7, NULL, 2, '华南分部', 0, TRUE, 'admin', 'admin', '2019-03-25 11:04:50', '2020-06-08 12:08:56');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (8, NULL, 2, '华北分部', 1, TRUE, 'admin', 'admin', '2019-03-25 11:04:53', '2020-05-14 12:54:00');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (15, 8, 0, 'UI部门', 7, TRUE, 'admin', 'admin', '2020-05-13 22:56:53', '2020-05-14 12:54:13');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (17, 2, 0, '研发一组', 999, TRUE, 'admin', 'admin', '2020-08-02 14:49:07', '2020-08-02 14:49:07');
-- 重置序列
SELECT setval('sys_dept_dept_id_seq', (SELECT MAX(dept_id) FROM sys_dept));
COMMIT;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
  dict_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE sys_dict IS '数据字典';
COMMENT ON COLUMN sys_dict.dict_id IS 'ID';
COMMENT ON COLUMN sys_dict.name IS '字典名称';
COMMENT ON COLUMN sys_dict.description IS '描述';
COMMENT ON COLUMN sys_dict.create_by IS '创建者';
COMMENT ON COLUMN sys_dict.update_by IS '更新者';
COMMENT ON COLUMN sys_dict.create_time IS '创建日期';
COMMENT ON COLUMN sys_dict.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
BEGIN;
INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (1, 'user_status', '用户状态', NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (4, 'dept_status', '部门状态', NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (5, 'job_status', '岗位状态', NULL, 'admin', '2019-10-27 20:31:36', '2025-01-14 15:48:29');
SELECT setval('sys_dict_dict_id_seq', (SELECT MAX(dict_id) FROM sys_dict));
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_detail
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_detail;
CREATE TABLE sys_dict_detail (
  detail_id BIGSERIAL PRIMARY KEY,
  dict_id BIGINT DEFAULT NULL,
  label VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  dict_sort INTEGER DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_dict_id ON sys_dict_detail(dict_id);
COMMENT ON TABLE sys_dict_detail IS '数据字典详情';
COMMENT ON COLUMN sys_dict_detail.detail_id IS 'ID';
COMMENT ON COLUMN sys_dict_detail.dict_id IS '字典id';
COMMENT ON COLUMN sys_dict_detail.label IS '字典标签';
COMMENT ON COLUMN sys_dict_detail.value IS '字典值';
COMMENT ON COLUMN sys_dict_detail.dict_sort IS '排序';
COMMENT ON COLUMN sys_dict_detail.create_by IS '创建者';
COMMENT ON COLUMN sys_dict_detail.update_by IS '更新者';
COMMENT ON COLUMN sys_dict_detail.create_time IS '创建日期';
COMMENT ON COLUMN sys_dict_detail.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_dict_detail
-- ----------------------------
BEGIN;
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (1, 1, '激活', 'true', 1, NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (2, 1, '禁用', 'false', 2, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (3, 4, '启用', 'true', 1, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (4, 4, '停用', 'false', 2, NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (5, 5, '启用', 'true', 1, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (6, 5, '停用', 'false', 2, NULL, NULL, '2019-10-27 20:31:36', NULL);
SELECT setval('sys_dict_detail_detail_id_seq', (SELECT MAX(detail_id) FROM sys_dict_detail));
COMMIT;

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS sys_job;
CREATE TABLE sys_job (
  job_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(180) NOT NULL UNIQUE,
  enabled BOOLEAN NOT NULL,
  job_sort INTEGER DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_enabled ON sys_job(enabled);
COMMENT ON TABLE sys_job IS '岗位';
COMMENT ON COLUMN sys_job.job_id IS 'ID';
COMMENT ON COLUMN sys_job.name IS '岗位名称';
COMMENT ON COLUMN sys_job.enabled IS '岗位状态';
COMMENT ON COLUMN sys_job.job_sort IS '排序';
COMMENT ON COLUMN sys_job.create_by IS '创建者';
COMMENT ON COLUMN sys_job.update_by IS '更新者';
COMMENT ON COLUMN sys_job.create_time IS '创建日期';
COMMENT ON COLUMN sys_job.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
BEGIN;
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (8, '人事专员', TRUE, 3, NULL, NULL, '2019-03-29 14:52:28', NULL);
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (10, '产品经理', TRUE, 4, NULL, NULL, '2019-03-29 14:55:51', NULL);
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (11, '全栈开发', TRUE, 2, NULL, 'admin', '2019-03-31 13:39:30', '2020-05-05 11:33:43');
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (12, '软件测试', TRUE, 5, NULL, 'admin', '2019-03-31 13:39:43', '2020-05-10 19:56:26');
SELECT setval('sys_job_job_id_seq', (SELECT MAX(job_id) FROM sys_job));
COMMIT;

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS sys_log;
CREATE TABLE sys_log (
  log_id BIGSERIAL PRIMARY KEY,
  description VARCHAR(255) DEFAULT NULL,
  log_type VARCHAR(10) NOT NULL,
  method VARCHAR(255) DEFAULT NULL,
  params TEXT DEFAULT NULL,
  request_ip VARCHAR(255) DEFAULT NULL,
  time BIGINT DEFAULT NULL,
  username VARCHAR(255) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  browser VARCHAR(255) DEFAULT NULL,
  exception_detail TEXT DEFAULT NULL,
  create_time TIMESTAMP NOT NULL
);
CREATE INDEX idx_create_time_index ON sys_log(create_time);
CREATE INDEX idx_log_type ON sys_log(log_type);
COMMENT ON TABLE sys_log IS '系统日志';
COMMENT ON COLUMN sys_log.log_id IS 'ID';
COMMENT ON COLUMN sys_log.description IS '描述';
COMMENT ON COLUMN sys_log.log_type IS '日志类型：INFI/ERROR';
COMMENT ON COLUMN sys_log.method IS '方法名';
COMMENT ON COLUMN sys_log.params IS '参数';
COMMENT ON COLUMN sys_log.request_ip IS '请求IP';
COMMENT ON COLUMN sys_log.time IS '执行时间';
COMMENT ON COLUMN sys_log.username IS '用户名';
COMMENT ON COLUMN sys_log.address IS '地址';
COMMENT ON COLUMN sys_log.browser IS '浏览器';
COMMENT ON COLUMN sys_log.exception_detail IS '异常';
COMMENT ON COLUMN sys_log.create_time IS '创建时间';

-- ----------------------------
-- Records of sys_log
-- ----------------------------
BEGIN;
INSERT INTO sys_log (log_id, description, log_type, method, params, request_ip, time, username, address, browser, exception_detail, create_time) VALUES (13753, '删除多个文件', 'INFO', 'me.zhengjie.rest.S3StorageController.deleteAllQiNiu()', '{"reqBodyList":[2]}', '127.0.0.1', 225, 'admin', '内网IP', 'Chrome 137', NULL, '2025-06-19 16:55:15');
SELECT setval('sys_log_log_id_seq', (SELECT MAX(log_id) FROM sys_log));
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
  menu_id BIGSERIAL PRIMARY KEY,
  pid BIGINT DEFAULT NULL,
  sub_count INTEGER DEFAULT 0,
  type INTEGER DEFAULT NULL,
  title VARCHAR(100) DEFAULT NULL UNIQUE,
  name VARCHAR(100) DEFAULT NULL UNIQUE,
  component VARCHAR(255) DEFAULT NULL,
  menu_sort INTEGER DEFAULT NULL,
  icon VARCHAR(255) DEFAULT NULL,
  path VARCHAR(255) DEFAULT NULL,
  i_frame BOOLEAN DEFAULT NULL,
  cache BOOLEAN DEFAULT FALSE,
  hidden BOOLEAN DEFAULT FALSE,
  permission VARCHAR(255) DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE INDEX idx_pid ON sys_menu(pid);
COMMENT ON TABLE sys_menu IS '系统菜单';
COMMENT ON COLUMN sys_menu.menu_id IS 'ID';
COMMENT ON COLUMN sys_menu.pid IS '上级菜单ID';
COMMENT ON COLUMN sys_menu.sub_count IS '子菜单数目';
COMMENT ON COLUMN sys_menu.type IS '菜单类型';
COMMENT ON COLUMN sys_menu.title IS '菜单标题';
COMMENT ON COLUMN sys_menu.name IS '组件名称';
COMMENT ON COLUMN sys_menu.component IS '组件';
COMMENT ON COLUMN sys_menu.menu_sort IS '排序';
COMMENT ON COLUMN sys_menu.icon IS '图标';
COMMENT ON COLUMN sys_menu.path IS '链接地址';
COMMENT ON COLUMN sys_menu.i_frame IS '是否外链';
COMMENT ON COLUMN sys_menu.cache IS '缓存';
COMMENT ON COLUMN sys_menu.hidden IS '隐藏';
COMMENT ON COLUMN sys_menu.permission IS '权限';
COMMENT ON COLUMN sys_menu.create_by IS '创建者';
COMMENT ON COLUMN sys_menu.update_by IS '更新者';
COMMENT ON COLUMN sys_menu.create_time IS '创建日期';
COMMENT ON COLUMN sys_menu.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (1, NULL, 7, 0, '系统管理', NULL, NULL, 1, 'system', 'system', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2018-12-18 15:11:29', '2025-01-14 15:48:18');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (2, 1, 3, 1, '用户管理', 'User', 'system/user/index', 2, 'peoples', 'user', FALSE, FALSE, FALSE, 'user:list', NULL, NULL, '2018-12-18 15:14:44', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (3, 1, 3, 1, '角色管理', 'Role', 'system/role/index', 3, 'role', 'role', FALSE, FALSE, FALSE, 'roles:list', NULL, NULL, '2018-12-18 15:16:07', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (5, 1, 3, 1, '菜单管理', 'Menu', 'system/menu/index', 5, 'menu', 'menu', FALSE, FALSE, FALSE, 'menu:list', NULL, NULL, '2018-12-18 15:17:28', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (6, NULL, 5, 0, '系统监控', NULL, NULL, 10, 'monitor', 'monitor', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-18 15:17:48', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (7, 6, 0, 1, '操作日志', 'Log', 'monitor/log/index', 11, 'log', 'logs', FALSE, TRUE, FALSE, NULL, NULL, 'admin', '2018-12-18 15:18:26', '2020-06-06 13:11:57');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (9, 6, 0, 1, 'SQL监控', 'Sql', 'monitor/sql/index', 18, 'sqlMonitor', 'druid', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-18 15:19:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (10, NULL, 5, 0, '组件管理', NULL, NULL, 50, 'zujian', 'components', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-19 13:38:16', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (11, 10, 0, 1, '图标库', 'Icons', 'components/icons/index', 51, 'icon', 'icon', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-19 13:38:49', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (14, 36, 0, 1, '邮件工具', 'Email', 'tools/email/index', 35, 'email', 'email', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-27 10:13:09', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (15, 10, 0, 1, '富文本', 'Editor', 'components/Editor', 52, 'fwb', 'tinymce', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-27 11:58:25', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (18, 36, 1, 1, '存储管理', 'Storage', 'tools/storage/index', 34, 'qiniu', 'storage', FALSE, FALSE, FALSE, 'storage:list', NULL, NULL, '2018-12-31 11:12:15', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (19, 36, 0, 1, '支付宝工具', 'AliPay', 'tools/aliPay/index', 37, 'alipay', 'aliPay', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-31 14:52:38', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (21, NULL, 2, 0, '多级菜单', NULL, '', 900, 'menu', 'nested', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2019-01-04 16:22:03', '2020-06-21 17:27:35');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (22, 21, 2, 0, '二级菜单1', NULL, '', 999, 'menu', 'menu1', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2019-01-04 16:23:29', '2020-06-21 17:27:20');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (23, 21, 0, 1, '二级菜单2', NULL, 'nested/menu2/index', 999, 'menu', 'menu2', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-04 16:23:57', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (24, 22, 0, 1, '三级菜单1', 'Test', 'nested/menu1/menu1-1', 999, 'menu', 'menu1-1', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-04 16:24:48', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (27, 22, 0, 1, '三级菜单2', NULL, 'nested/menu1/menu1-2', 999, 'menu', 'menu1-2', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-07 17:27:32', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (28, 1, 3, 1, '任务调度', 'Timing', 'system/timing/index', 999, 'timing', 'timing', FALSE, FALSE, FALSE, 'timing:list', NULL, NULL, '2019-01-07 20:34:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (30, 36, 0, 1, '代码生成', 'GeneratorIndex', 'generator/index', 32, 'dev', 'generator', FALSE, TRUE, FALSE, NULL, NULL, NULL, '2019-01-11 15:45:55', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (32, 6, 0, 1, '异常日志', 'ErrorLog', 'monitor/log/errorLog', 12, 'error', 'errorLog', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-13 13:49:03', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (33, 10, 0, 1, 'Markdown', 'Markdown', 'components/MarkDown', 53, 'markdown', 'markdown', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-08 13:46:44', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (34, 10, 0, 1, 'Yaml编辑器', 'YamlEdit', 'components/YamlEdit', 54, 'dev', 'yaml', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-08 15:49:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (35, 1, 3, 1, '部门管理', 'Dept', 'system/dept/index', 6, 'dept', 'dept', FALSE, FALSE, FALSE, 'dept:list', NULL, NULL, '2019-03-25 09:46:00', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (36, NULL, 6, 0, '系统工具', NULL, '', 30, 'sys-tools', 'sys-tools', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-29 10:57:35', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (37, 1, 3, 1, '岗位管理', 'Job', 'system/job/index', 7, 'Steve-Jobs', 'job', FALSE, FALSE, FALSE, 'job:list', NULL, NULL, '2019-03-29 13:51:18', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (39, 1, 3, 1, '字典管理', 'Dict', 'system/dict/index', 8, 'dictionary', 'dict', FALSE, FALSE, FALSE, 'dict:list', NULL, NULL, '2019-04-10 11:49:04', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (41, 6, 0, 1, '在线用户', 'OnlineUser', 'monitor/online/index', 10, 'Steve-Jobs', 'online', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-10-26 22:08:43', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (44, 2, 0, 2, '用户新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'user:add', NULL, NULL, '2019-10-29 10:59:46', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (45, 2, 0, 2, '用户编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'user:edit', NULL, NULL, '2019-10-29 11:00:08', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (46, 2, 0, 2, '用户删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'user:del', NULL, NULL, '2019-10-29 11:00:23', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (48, 3, 0, 2, '角色创建', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'roles:add', NULL, NULL, '2019-10-29 12:45:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (49, 3, 0, 2, '角色修改', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'roles:edit', NULL, NULL, '2019-10-29 12:46:16', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (50, 3, 0, 2, '角色删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'roles:del', NULL, NULL, '2019-10-29 12:46:51', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (52, 5, 0, 2, '菜单新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'menu:add', NULL, NULL, '2019-10-29 12:55:07', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (53, 5, 0, 2, '菜单编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'menu:edit', NULL, NULL, '2019-10-29 12:55:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (54, 5, 0, 2, '菜单删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'menu:del', NULL, NULL, '2019-10-29 12:56:00', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (56, 35, 0, 2, '部门新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'dept:add', NULL, NULL, '2019-10-29 12:57:09', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (57, 35, 0, 2, '部门编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'dept:edit', NULL, NULL, '2019-10-29 12:57:27', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (58, 35, 0, 2, '部门删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'dept:del', NULL, NULL, '2019-10-29 12:57:41', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (60, 37, 0, 2, '岗位新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'job:add', NULL, NULL, '2019-10-29 12:58:27', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (61, 37, 0, 2, '岗位编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'job:edit', NULL, NULL, '2019-10-29 12:58:45', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (62, 37, 0, 2, '岗位删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'job:del', NULL, NULL, '2019-10-29 12:59:04', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (64, 39, 0, 2, '字典新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'dict:add', NULL, NULL, '2019-10-29 13:00:17', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (65, 39, 0, 2, '字典编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'dict:edit', NULL, NULL, '2019-10-29 13:00:42', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (66, 39, 0, 2, '字典删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'dict:del', NULL, NULL, '2019-10-29 13:00:59', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (73, 28, 0, 2, '任务新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'timing:add', NULL, NULL, '2019-10-29 13:07:28', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (74, 28, 0, 2, '任务编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'timing:edit', NULL, NULL, '2019-10-29 13:07:41', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (75, 28, 0, 2, '任务删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'timing:del', NULL, NULL, '2019-10-29 13:07:54', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (79, 18, 0, 2, '文件删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'storage:del', NULL, NULL, '2019-10-29 13:09:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (80, 6, 0, 1, '服务监控', 'ServerMonitor', 'monitor/server/index', 14, 'codeConsole', 'server', FALSE, FALSE, FALSE, 'monitor:list', NULL, 'admin', '2019-11-07 13:06:39', '2020-05-04 18:20:50');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (82, 36, 0, 1, '生成配置', 'GeneratorConfig', 'generator/config', 33, 'dev', 'generator/config/:tableName', FALSE, TRUE, TRUE, '', NULL, NULL, '2019-11-17 20:08:56', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (83, 10, 0, 1, '图表库', 'Echarts', 'components/Echarts', 50, 'chart', 'echarts', FALSE, TRUE, FALSE, '', NULL, NULL, '2019-11-21 09:04:32', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (90, NULL, 5, 1, '运维管理', 'Mnt', '', 20, 'mnt', 'mnt', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-11-09 10:31:08', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (92, 90, 3, 1, '服务器', 'ServerDeploy', 'maint/server/index', 22, 'server', 'maint/serverDeploy', FALSE, FALSE, FALSE, 'serverDeploy:list', NULL, NULL, '2019-11-10 10:29:25', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (93, 90, 3, 1, '应用管理', 'App', 'maint/app/index', 23, 'app', 'maint/app', FALSE, FALSE, FALSE, 'app:list', NULL, NULL, '2019-11-10 11:05:16', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (94, 90, 3, 1, '部署管理', 'Deploy', 'maint/deploy/index', 24, 'deploy', 'maint/deploy', FALSE, FALSE, FALSE, 'deploy:list', NULL, NULL, '2019-11-10 15:56:55', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (97, 90, 1, 1, '部署备份', 'DeployHistory', 'maint/deployHistory/index', 25, 'backup', 'maint/deployHistory', FALSE, FALSE, FALSE, 'deployHistory:list', NULL, NULL, '2019-11-10 16:49:44', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (98, 90, 3, 1, '数据库管理', 'Database', 'maint/database/index', 26, 'database', 'maint/database', FALSE, FALSE, FALSE, 'database:list', NULL, NULL, '2019-11-10 20:40:04', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (102, 97, 0, 2, '删除', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'deployHistory:del', NULL, NULL, '2019-11-17 09:32:48', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (103, 92, 0, 2, '服务器新增', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'serverDeploy:add', NULL, NULL, '2019-11-17 11:08:33', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (104, 92, 0, 2, '服务器编辑', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'serverDeploy:edit', NULL, NULL, '2019-11-17 11:08:57', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (105, 92, 0, 2, '服务器删除', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'serverDeploy:del', NULL, NULL, '2019-11-17 11:09:15', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (106, 93, 0, 2, '应用新增', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'app:add', NULL, NULL, '2019-11-17 11:10:03', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (107, 93, 0, 2, '应用编辑', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'app:edit', NULL, NULL, '2019-11-17 11:10:28', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (108, 93, 0, 2, '应用删除', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'app:del', NULL, NULL, '2019-11-17 11:10:55', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (109, 94, 0, 2, '部署新增', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'deploy:add', NULL, NULL, '2019-11-17 11:11:22', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (110, 94, 0, 2, '部署编辑', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'deploy:edit', NULL, NULL, '2019-11-17 11:11:41', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (111, 94, 0, 2, '部署删除', NULL, '', 999, '', '', FALSE, FALSE, FALSE, 'deploy:del', NULL, NULL, '2019-11-17 11:12:01', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (116, 36, 0, 1, '生成预览', 'Preview', 'generator/preview', 999, 'java', 'generator/preview/:tableName', FALSE, TRUE, TRUE, NULL, NULL, NULL, '2019-11-26 14:54:36', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_quartz_job
-- ----------------------------
DROP TABLE IF EXISTS sys_quartz_job;
CREATE TABLE sys_quartz_job (
  job_id BIGSERIAL,
  bean_name VARCHAR(255) DEFAULT NULL,
  cron_expression VARCHAR(255) DEFAULT NULL,
  is_pause BOOLEAN DEFAULT NULL,
  job_name VARCHAR(255) DEFAULT NULL,
  method_name VARCHAR(255) DEFAULT NULL,
  params VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL,
  person_in_charge VARCHAR(100) DEFAULT NULL,
  email VARCHAR(100) DEFAULT NULL,
  sub_task VARCHAR(100) DEFAULT NULL,
  pause_after_failure BOOLEAN DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL,
  PRIMARY KEY (job_id)
);

-- ----------------------------
-- Records of sys_quartz_job
-- ----------------------------
BEGIN;
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (2, 'testTask', '0/5 * * * * ?', TRUE, '测试1', 'run1', 'test', '带参测试，多参使用json', '测试', NULL, NULL, NULL, NULL, 'admin', '2019-08-22 14:08:29', '2020-05-24 13:58:33');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (3, 'testTask', '0/5 * * * * ?', TRUE, '测试', 'run', '', '不带参测试', 'Zheng Jie', '', '6', TRUE, NULL, 'admin', '2019-09-26 16:44:39', '2020-05-24 14:48:12');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (5, 'Test', '0/5 * * * * ?', TRUE, '任务告警测试', 'run', NULL, '测试', 'test', '', NULL, TRUE, 'admin', 'admin', '2020-05-05 20:32:41', '2020-05-05 20:36:13');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (6, 'testTask', '0/5 * * * * ?', TRUE, '测试3', 'run2', NULL, '测试3', 'Zheng Jie', '', NULL, TRUE, 'admin', 'admin', '2020-05-05 20:35:41', '2020-05-05 20:36:07');
COMMIT;

-- ----------------------------
-- Table structure for sys_quartz_log
-- ----------------------------
DROP TABLE IF EXISTS sys_quartz_log;
CREATE TABLE sys_quartz_log (
  log_id BIGSERIAL,
  bean_name VARCHAR(255) DEFAULT NULL,
  cron_expression VARCHAR(255) DEFAULT NULL,
  is_success BOOLEAN DEFAULT NULL,
  job_name VARCHAR(255) DEFAULT NULL,
  method_name VARCHAR(255) DEFAULT NULL,
  params VARCHAR(255) DEFAULT NULL,
  time BIGINT DEFAULT NULL,
  exception_detail TEXT DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  PRIMARY KEY (log_id)
);

-- ----------------------------
-- Records of sys_quartz_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
  role_id BIGSERIAL,
  name VARCHAR(100) NOT NULL,
  level INTEGER DEFAULT NULL,
  data_scope VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL,
  PRIMARY KEY (role_id)
);

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO sys_role (role_id, name, level, data_scope, description, create_by, update_by, create_time, update_time) VALUES (1, '管理员', 1, '全部', NULL, NULL, 'admin', '2018-11-23 11:04:37', '2020-08-06 16:10:24');
INSERT INTO sys_role (role_id, name, level, data_scope, description, create_by, update_by, create_time, update_time) VALUES (2, '普通用户', 2, '本级', NULL, NULL, 'admin', '2018-11-23 13:09:06', '2020-09-05 10:45:12');
COMMIT;

-- ----------------------------
-- Table structure for sys_roles_depts
-- ----------------------------
DROP TABLE IF EXISTS sys_roles_depts;
CREATE TABLE sys_roles_depts (
  role_id BIGINT NOT NULL,
  dept_id BIGINT NOT NULL,
  PRIMARY KEY (role_id,dept_id)
);

-- ----------------------------
-- Records of sys_roles_depts
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_roles_menus
-- ----------------------------
DROP TABLE IF EXISTS sys_roles_menus;
CREATE TABLE sys_roles_menus (
  menu_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  PRIMARY KEY (menu_id,role_id)
);

-- ----------------------------
-- Records of sys_roles_menus
-- ----------------------------
BEGIN;
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (1, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (1, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (2, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (2, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (3, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (5, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (6, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (6, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (7, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (7, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (9, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (9, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (10, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (10, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (11, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (11, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (14, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (14, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (15, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (15, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (18, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (19, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (19, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (21, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (21, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (22, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (22, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (23, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (23, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (24, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (24, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (27, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (27, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (28, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (30, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (30, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (32, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (32, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (33, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (33, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (34, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (34, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (35, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (36, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (36, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (37, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (39, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (41, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (44, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (45, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (46, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (48, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (49, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (50, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (52, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (53, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (54, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (56, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (57, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (58, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (60, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (61, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (62, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (64, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (65, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (66, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (73, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (74, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (75, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (79, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (80, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (80, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (82, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (82, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (83, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (83, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (90, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (92, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (93, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (94, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (97, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (98, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (102, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (103, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (104, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (105, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (106, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (107, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (108, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (109, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (110, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (111, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (116, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (116, 2);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
  user_id BIGSERIAL PRIMARY KEY,
  dept_id BIGINT DEFAULT NULL,
  username VARCHAR(180) DEFAULT NULL,
  nick_name VARCHAR(255) DEFAULT NULL,
  gender VARCHAR(2) DEFAULT NULL,
  phone VARCHAR(255) DEFAULT NULL,
  email VARCHAR(180) DEFAULT NULL,
  avatar_name VARCHAR(255) DEFAULT NULL,
  avatar_path VARCHAR(255) DEFAULT NULL,
  password VARCHAR(255) DEFAULT NULL,
  is_admin BOOLEAN DEFAULT FALSE,
  enabled BOOLEAN DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  pwd_reset_time TIMESTAMP DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL
);
CREATE UNIQUE INDEX uniq_email ON sys_user(email);
CREATE UNIQUE INDEX uniq_username ON sys_user(username);
CREATE INDEX idx_dept_id ON sys_user(dept_id);
CREATE INDEX idx_enabled ON sys_user(enabled);
COMMENT ON TABLE sys_user IS '系统用户';
COMMENT ON COLUMN sys_user.user_id IS 'ID';
COMMENT ON COLUMN sys_user.dept_id IS '部门名称';
COMMENT ON COLUMN sys_user.username IS '用户名';
COMMENT ON COLUMN sys_user.nick_name IS '昵称';
COMMENT ON COLUMN sys_user.gender IS '性别';
COMMENT ON COLUMN sys_user.phone IS '手机号码';
COMMENT ON COLUMN sys_user.email IS '邮箱';
COMMENT ON COLUMN sys_user.avatar_name IS '头像地址';
COMMENT ON COLUMN sys_user.avatar_path IS '头像真实路径';
COMMENT ON COLUMN sys_user.password IS '密码';
COMMENT ON COLUMN sys_user.is_admin IS '是否为admin账号';
COMMENT ON COLUMN sys_user.enabled IS '状态：1启用、0禁用';
COMMENT ON COLUMN sys_user.create_by IS '创建者';
COMMENT ON COLUMN sys_user.update_by IS '更新者';
COMMENT ON COLUMN sys_user.pwd_reset_time IS '修改密码的时间';
COMMENT ON COLUMN sys_user.create_time IS '创建日期';
COMMENT ON COLUMN sys_user.update_time IS '更新时间';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO sys_user (user_id, dept_id, username, nick_name, gender, phone, email, avatar_name, avatar_path, password, is_admin, enabled, create_by, update_by, pwd_reset_time, create_time, update_time) VALUES (1, 2, 'admin', '管理员', '男', '18888888888', '201507802@qq.com', 'avatar-20250121112710866.png', '/Users/jie/Documents/work/private/eladmin-mp/~/avatar/avatar-20250121112710866.png', '$2a$10$Egp1/gvFlt7zhlXVfEFw4OfWQCGPw0ClmMcc6FjTnvXNRVf9zdMRa', TRUE, TRUE, NULL, 'admin', '2020-05-03 16:38:31', '2018-08-23 09:11:56', '2020-09-05 10:43:31');
INSERT INTO sys_user (user_id, dept_id, username, nick_name, gender, phone, email, avatar_name, avatar_path, password, is_admin, enabled, create_by, update_by, pwd_reset_time, create_time, update_time) VALUES (2, 2, 'test', '测试', '男', '19999999999', '231@qq.com', NULL, NULL, '$2a$10$BSR9oUNtzWhnqs8NmZk5Zu3zfsNop3KxZO0xGEzy01cumf9k/AW6.', FALSE, TRUE, 'admin', 'admin', '2025-01-21 15:25:12', '2020-05-05 11:15:49', '2020-09-05 10:43:38');
SELECT setval('sys_user_user_id_seq', (SELECT MAX(user_id) FROM sys_user));
COMMIT;

-- ----------------------------
-- Table structure for sys_users_jobs
-- ----------------------------
DROP TABLE IF EXISTS sys_users_jobs;
CREATE TABLE sys_users_jobs (
  user_id BIGINT NOT NULL,
  job_id BIGINT NOT NULL,
  PRIMARY KEY (user_id,job_id)
);
CREATE INDEX idx_user_id ON sys_users_jobs(user_id);
CREATE INDEX idx_job_id ON sys_users_jobs(job_id);
COMMENT ON TABLE sys_users_jobs IS '用户与岗位关联表';
COMMENT ON COLUMN sys_users_jobs.user_id IS '用户ID';
COMMENT ON COLUMN sys_users_jobs.job_id IS '岗位ID';

-- ----------------------------
-- Records of sys_users_jobs
-- ----------------------------
BEGIN;
INSERT INTO sys_users_jobs (user_id, job_id) VALUES (1, 11);
INSERT INTO sys_users_jobs (user_id, job_id) VALUES (2, 11);
COMMIT;

-- ----------------------------
-- Table structure for sys_users_roles
-- ----------------------------
DROP TABLE IF EXISTS sys_users_roles;
CREATE TABLE sys_users_roles (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  PRIMARY KEY (user_id,role_id)
);

-- ----------------------------
-- Records of sys_users_roles
-- ----------------------------
BEGIN;
INSERT INTO sys_users_roles (user_id, role_id) VALUES (1, 1);
INSERT INTO sys_users_roles (user_id, role_id) VALUES (2, 2);
COMMIT;

-- ----------------------------
-- Table structure for tool_alipay_config
-- ----------------------------
DROP TABLE IF EXISTS tool_alipay_config;
CREATE TABLE tool_alipay_config (
  config_id BIGINT NOT NULL,
  app_id VARCHAR(255) DEFAULT NULL,
  charset VARCHAR(255) DEFAULT NULL,
  format VARCHAR(255) DEFAULT NULL,
  gateway_url VARCHAR(255) DEFAULT NULL,
  notify_url VARCHAR(255) DEFAULT NULL,
  private_key TEXT DEFAULT NULL,
  public_key TEXT DEFAULT NULL,
  return_url VARCHAR(255) DEFAULT NULL,
  sign_type VARCHAR(255) DEFAULT NULL,
  sys_service_provider_id VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (config_id)
);

-- ----------------------------
-- Records of tool_alipay_config
-- ----------------------------
BEGIN;
INSERT INTO tool_alipay_config (config_id, app_id, charset, format, gateway_url, notify_url, private_key, public_key, return_url, sign_type, sys_service_provider_id) VALUES (1, '2016091700532697', 'utf-8', 'JSON', 'https://openapi.alipaydev.com/gateway.do', 'http://api.auauz.net/api/aliPay/notify', 'MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5js8sInU10AJ0cAQ8UMMyXrQ+oHZEkVt5lBwsStmTJ7YikVYgbskx1YYEXTojRsWCb+SH/kDmDU4pK/u91SJ4KFCRMF2411piYuXU/jF96zKrADznYh/zAraqT6hvAIVtQAlMHN53nx16rLzZ/8jDEkaSwT7+HvHiS+7sxSojnu/3oV7BtgISoUNstmSe8WpWHOaWv19xyS+Mce9MY4BfseFhzTICUymUQdd/8hXA28/H6osUfAgsnxAKv7Wil3aJSgaJczWuflYOve0dJ3InZkhw5Cvr0atwpk8YKBQjy5CdkoHqvkOcIB+cYHXJKzOE5tqU7inSwVbHzOLQ3XbnAgMBAAECggEAVJp5eT0Ixg1eYSqFs9568WdetUNCSUchNxDBu6wxAbhUgfRUGZuJnnAll63OCTGGck+EGkFh48JjRcBpGoeoHLL88QXlZZbC/iLrea6gcDIhuvfzzOffe1RcZtDFEj9hlotg8dQj1tS0gy9pN9g4+EBH7zeu+fyv+qb2e/v1l6FkISXUjpkD7RLQr3ykjiiEw9BpeKb7j5s7Kdx1NNIzhkcQKNqlk8JrTGDNInbDM6inZfwwIO2R1DHinwdfKWkvOTODTYa2MoAvVMFT9Bec9FbLpoWp7ogv1JMV9svgrcF9XLzANZ/OQvkbe9TV9GWYvIbxN6qwQioKCWO4GPnCAQKBgQDgW5MgfhX8yjXqoaUy/d1VjI8dHeIyw8d+OBAYwaxRSlCfyQ+tieWcR2HdTzPca0T0GkWcKZm0ei5xRURgxt4DUDLXNh26HG0qObbtLJdu/AuBUuCqgOiLqJ2f1uIbrz6OZUHns+bT/jGW2Ws8+C13zTCZkZt9CaQsrp3QOGDx5wKBgQDTul39hp3ZPwGNFeZdkGoUoViOSd5Lhowd5wYMGAEXWRLlU8z+smT5v0POz9JnIbCRchIY2FAPKRdVTICzmPk2EPJFxYTcwaNbVqL6lN7J2IlXXMiit5QbiLauo55w7plwV6LQmKm9KV7JsZs5XwqF7CEovI7GevFzyD3w+uizAQKBgC3LY1eRhOlpWOIAhpjG6qOoohmeXOphvdmMlfSHq6WYFqbWwmV4rS5d/6LNpNdL6fItXqIGd8I34jzql49taCmi+A2nlR/E559j0mvM20gjGDIYeZUz5MOE8k+K6/IcrhcgofgqZ2ZED1ksHdB/E8DNWCswZl16V1FrfvjeWSNnAoGAMrBplCrIW5xz+J0Hm9rZKrs+AkK5D4fUv8vxbK/KgxZ2KaUYbNm0xv39c+PZUYuFRCz1HDGdaSPDTE6WeWjkMQd5mS6ikl9hhpqFRkyh0d0fdGToO9yLftQKOGE/q3XUEktI1XvXF0xyPwNgUCnq0QkpHyGVZPtGFxwXiDvpvgECgYA5PoB+nY8iDiRaJNko9w0hL4AeKogwf+4TbCw+KWVEn6jhuJa4LFTdSqp89PktQaoVpwv92el/AhYjWOl/jVCm122f9b7GyoelbjMNolToDwe5pF5RnSpEuDdLy9MfE8LnE3PlbE7E5BipQ3UjSebkgNboLHH/lNZA5qvEtvbfvQ==', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAut9evKRuHJ/2QNfDlLwvN/S8l9hRAgPbb0u61bm4AtzaTGsLeMtScetxTWJnVvAVpMS9luhEJjt+Sbk5TNLArsgzzwARgaTKOLMT1TvWAK5EbHyI+eSrc3s7Awe1VYGwcubRFWDm16eQLv0k7iqiw+4mweHSz/wWyvBJVgwLoQ02btVtAQErCfSJCOmt0Q/oJQjj08YNRV4EKzB19+f5A+HQVAKy72dSybTzAK+3FPtTtNen/+b5wGeat7c32dhYHnGorPkPeXLtsqqUTp1su5fMfd4lElNdZaoCI7osZxWWUo17vBCZnyeXc9fk0qwD9mK6yRAxNbrY72Xx5VqIqwIDAQAB', 'http://api.auauz.net/api/aliPay/return', 'RSA2', '2088102176044281');
COMMIT;

-- ----------------------------
-- Table structure for tool_email_config
-- ----------------------------
DROP TABLE IF EXISTS tool_email_config;
CREATE TABLE tool_email_config (
  config_id BIGINT NOT NULL,
  from_user VARCHAR(255) DEFAULT NULL,
  host VARCHAR(255) DEFAULT NULL,
  pass VARCHAR(255) DEFAULT NULL,
  port VARCHAR(255) DEFAULT NULL,
  user VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (config_id)
);

-- ----------------------------
-- Records of tool_email_config
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tool_local_storage
-- ----------------------------
DROP TABLE IF EXISTS tool_local_storage;
CREATE TABLE tool_local_storage (
  storage_id BIGSERIAL,
  real_name VARCHAR(255) DEFAULT NULL,
  name VARCHAR(255) DEFAULT NULL,
  suffix VARCHAR(255) DEFAULT NULL,
  path VARCHAR(255) DEFAULT NULL,
  type VARCHAR(255) DEFAULT NULL,
  size VARCHAR(256) DEFAULT NULL,
  create_by VARCHAR(255) DEFAULT NULL,
  update_by VARCHAR(255) DEFAULT NULL,
  create_time TIMESTAMP DEFAULT NULL,
  update_time TIMESTAMP DEFAULT NULL,
  PRIMARY KEY (storage_id)
);

-- ----------------------------
-- Records of tool_local_storage
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tool_s3_storage
-- ----------------------------
DROP TABLE IF EXISTS tool_s3_storage;
CREATE TABLE tool_s3_storage (
  storage_id BIGSERIAL,
  file_name VARCHAR(255) NOT NULL,
  file_real_name VARCHAR(255) NOT NULL,
  file_size VARCHAR(100) NOT NULL,
  file_mime_type VARCHAR(50) NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  file_path TEXT NOT NULL,
  create_by VARCHAR(255) NOT NULL,
  update_by VARCHAR(255) NOT NULL,
  create_time TIMESTAMP NOT NULL,
  update_time TIMESTAMP NOT NULL,
  PRIMARY KEY (storage_id)
);

-- ----------------------------
-- Records of tool_s3_storage
-- ----------------------------
BEGIN;
COMMIT;


-- 邮箱验证码表
CREATE TABLE sys_email_verify_code (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  code VARCHAR(10) NOT NULL,
  type VARCHAR(20) NOT NULL,
  expire_time TIMESTAMP NOT NULL,
  used BOOLEAN NOT NULL DEFAULT false,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  used_time TIMESTAMP DEFAULT NULL
);

-- 添加注释
COMMENT ON TABLE sys_email_verify_code IS '邮箱验证码表';
COMMENT ON COLUMN sys_email_verify_code.id IS 'ID';
COMMENT ON COLUMN sys_email_verify_code.email IS '邮箱地址';
COMMENT ON COLUMN sys_email_verify_code.code IS '验证码';
COMMENT ON COLUMN sys_email_verify_code.type IS '验证码类型：register-注册，login-登录，reset-重置密码';
COMMENT ON COLUMN sys_email_verify_code.expire_time IS '过期时间';
COMMENT ON COLUMN sys_email_verify_code.used IS '是否已使用';
COMMENT ON COLUMN sys_email_verify_code.create_time IS '创建时间';
COMMENT ON COLUMN sys_email_verify_code.used_time IS '使用时间';

-- 创建索引
CREATE INDEX idx_email_type ON sys_email_verify_code(email, type);
CREATE INDEX idx_create_time ON sys_email_verify_code(create_time);

-- GitHub 热门项目表（PostgreSQL 版本）
CREATE TABLE IF NOT EXISTS github_trending_projects (
    id BIGSERIAL PRIMARY KEY,
    repo_name VARCHAR(500) NOT NULL,
    title VARCHAR(500),
    description TEXT,
    original_description TEXT,
    stars INTEGER,
    forks INTEGER,
    language VARCHAR(100),
    repo_url VARCHAR(500),
    trend_period VARCHAR(50) DEFAULT 'daily',
    analysis_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(repo_name, trend_period)
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_github_repo_name ON github_trending_projects(repo_name);
CREATE INDEX IF NOT EXISTS idx_github_language ON github_trending_projects(language);
CREATE INDEX IF NOT EXISTS idx_github_created_at ON github_trending_projects(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_github_stars ON github_trending_projects(stars DESC);

-- 添加注释
COMMENT ON TABLE github_trending_projects IS 'GitHub 热门项目';
COMMENT ON COLUMN github_trending_projects.id IS '主键ID';
COMMENT ON COLUMN github_trending_projects.repo_name IS '仓库名称（owner/repo）';
COMMENT ON COLUMN github_trending_projects.title IS '项目标题（中文）';
COMMENT ON COLUMN github_trending_projects.description IS '项目简介（中文）';
COMMENT ON COLUMN github_trending_projects.original_description IS '原始英文描述';
COMMENT ON COLUMN github_trending_projects.stars IS '星标数';
COMMENT ON COLUMN github_trending_projects.forks IS 'Fork 数';
COMMENT ON COLUMN github_trending_projects.language IS '主要编程语言';
COMMENT ON COLUMN github_trending_projects.repo_url IS '仓库URL';
COMMENT ON COLUMN github_trending_projects.trend_period IS '趋势周期';
COMMENT ON COLUMN github_trending_projects.analysis_data IS 'AI分析的完整数据（JSONB）';
COMMENT ON COLUMN github_trending_projects.created_at IS '创建时间';
COMMENT ON COLUMN github_trending_projects.updated_at IS '更新时间';

-- 插入 Google Gemini API Key 到数据字典
DO $$
DECLARE
    v_dict_id BIGINT;
BEGIN
    -- 检查并插入字典
    SELECT dict_id INTO v_dict_id FROM sys_dict WHERE name = 'ai_api_keys';
    
    IF v_dict_id IS NULL THEN
        INSERT INTO sys_dict (name, description) 
        VALUES ('ai_api_keys', 'AI服务API密钥')
        RETURNING dict_id INTO v_dict_id;
    END IF;
    
    -- 检查并插入字典详情
    IF NOT EXISTS (
        SELECT 1 FROM sys_dict_detail 
        WHERE dict_id = v_dict_id
        AND label = 'Google Gemini API Key'
    ) THEN
        INSERT INTO sys_dict_detail (dict_id, label, value, dict_sort) 
        VALUES (v_dict_id, 'Google Gemini API Key', 'your-google-gemini-api-key-here', 1);
    END IF;
    
    RAISE NOTICE 'AI API Keys 字典配置完成';
END $$;


-- GPT-4o Image Prompts 数据表（PostgreSQL）
CREATE TABLE IF NOT EXISTS gpt4o_prompts (
    id BIGSERIAL PRIMARY KEY,
    prompt_id VARCHAR(255) UNIQUE,
    title VARCHAR(500),
    description TEXT,
    prompt_text TEXT NOT NULL,
    category VARCHAR(100),
    tags TEXT[],
    image_path VARCHAR(500),
    extra_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_prompts_title ON gpt4o_prompts USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_prompts_description ON gpt4o_prompts USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_prompts_prompt_text ON gpt4o_prompts USING gin(to_tsvector('english', prompt_text));
CREATE INDEX IF NOT EXISTS idx_prompts_category ON gpt4o_prompts(category);
CREATE INDEX IF NOT EXISTS idx_prompts_tags ON gpt4o_prompts USING gin(tags);
CREATE INDEX IF NOT EXISTS idx_prompts_created_at ON gpt4o_prompts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_prompts_extra_data ON gpt4o_prompts USING gin(extra_data);

-- 添加注释
COMMENT ON TABLE gpt4o_prompts IS 'GPT-4o 图像生成提示词';
COMMENT ON COLUMN gpt4o_prompts.id IS '主键ID';
COMMENT ON COLUMN gpt4o_prompts.prompt_id IS '提示词唯一标识';
COMMENT ON COLUMN gpt4o_prompts.title IS '标题';
COMMENT ON COLUMN gpt4o_prompts.description IS '描述';
COMMENT ON COLUMN gpt4o_prompts.prompt_text IS '提示词内容';
COMMENT ON COLUMN gpt4o_prompts.category IS '分类';
COMMENT ON COLUMN gpt4o_prompts.tags IS '标签数组';
COMMENT ON COLUMN gpt4o_prompts.image_path IS '示例图片相对路径';
COMMENT ON COLUMN gpt4o_prompts.extra_data IS '完整JSON数据（JSONB）';
COMMENT ON COLUMN gpt4o_prompts.created_at IS '创建时间';
COMMENT ON COLUMN gpt4o_prompts.updated_at IS '更新时间';
