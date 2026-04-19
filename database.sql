-- 贷款线索中台数据库表结构
-- 在Supabase SQL编辑器中执行

-- 表1：users （员工表）
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  name VARCHAR(50) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'staff'
);

-- 表2：leads （线索主表）
CREATE TABLE leads (
  id BIGSERIAL PRIMARY KEY,
  phone VARCHAR(100) UNIQUE NOT NULL,
  raw_name VARCHAR(50),
  source_app VARCHAR(50) NOT NULL DEFAULT 'manual',
  source_detail VARCHAR(255),
  intent_type VARCHAR(50),
  status VARCHAR(20) NOT NULL DEFAULT 'pool',
  owner_id BIGINT DEFAULT 0,
  last_follow_time TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引优化查询
CREATE INDEX idx_leads_owner ON leads(owner_id);
CREATE INDEX idx_leads_status ON leads(status);
CREATE INDEX idx_leads_owner_status ON leads(owner_id, status);
CREATE INDEX idx_leads_last_follow ON leads(last_follow_time DESC);

-- 创建follow_records表（跟进记录）
CREATE TABLE follow_records (
  id BIGSERIAL PRIMARY KEY,
  lead_id BIGINT NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  staff_id BIGINT NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_follow_lead ON follow_records(lead_id);
CREATE INDEX idx_follow_created ON follow_records(created_at DESC);

-- 抢单核心RPC函数（防止并发问题）
-- 在Supabase SQL编辑器中执行创建
CREATE OR REPLACE FUNCTION grab_lead(p_lead_id BIGINT, p_staff_id BIGINT)
RETURNS BOOLEAN AS $$
DECLARE
  affected_rows INTEGER;
BEGIN
  -- 使用UPDATE...WHERE进行原子性操作
  -- 只有owner_id=0的线索才能被抢
  UPDATE leads 
  SET owner_id = p_staff_id, 
      status = 'following'
  WHERE id = p_lead_id 
    AND owner_id = 0 
    AND status = 'pool';
  
  GET DIAGNOSTICS affected_rows = ROW_COUNT;
  
  -- 返回true表示抢到，false表示已被抢走
  RETURN affected_rows = 1;
END;
$$ LANGUAGE plpgsql;

-- 插入测试数据（可选）
-- INSERT INTO users (phone, password, name, role) VALUES ('13800138000', '123456', '张老板', 'boss');
-- INSERT INTO users (phone, password, name, role) VALUES ('13800138001', '123456', '李业务员', 'staff');
-- INSERT INTO users (phone, password, name, role) VALUES ('13800138002', '123456', '王业务员', 'staff');
