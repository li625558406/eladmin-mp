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
