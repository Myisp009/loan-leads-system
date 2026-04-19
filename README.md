# 贷款线索中台 V1.0

> 零成本部署，像素级实现需求文档

## 技术栈

- **前端框架**: Vue 3 + Vant UI (移动端组件库)
- **后端+数据库**: Supabase (PostgreSQL + 认证)
- **部署**: Vercel (免费CDN + HTTPS)

## 零成本特性

- ✅ 无需购买服务器
- ✅ 无需购买域名
- ✅ 无需购买SSL证书
- ✅ 无需购买数据库
- ✅ 无需购买短信API

## 快速开始

### 1. 配置Supabase

1. 访问 [https://supabase.com](https://supabase.com) 注册账号
2. 创建新项目
3. 打开SQL编辑器，执行 `database.sql` 中的全部SQL
4. 在 `users` 表中插入测试员工数据
5. 复制项目URL和Anon Key

### 2. 本地开发

```bash
# 安装依赖
npm install

# 配置环境变量
# 将.env.example复制为.env.local并填入你的Supabase配置

# 启动开发服务器
npm run dev
```

### 3. 部署到Vercel

```bash
# 安装Vercel CLI
npm i -g vercel

# 部署
vercel --prod
```

部署后会获得 `.vercel.app` 结尾的免费域名。

## 页面说明

| 页面 | 路径 | 说明 |
|------|------|------|
| 登录页 | `/login` | 员工登录入口 |
| 业务员工作台 | `/staff` | 核心业务页面，展示客户列表、跟进、抢单 |
| 抢单池 | `/pool` | 公海线索列表，可领取 |
| 老板看板 | `/boss` | 数据统计、员工排行、全库搜索 |

## 核心功能验证

### 1. 撞单测试
- 员工A录入号码 13800138001
- 员工B录入相同号码
- 系统提示"号码已存在"

### 2. 脱敏测试
- 所有列表中手机号显示为 `138****5678`
- F12检查代码中无明文手机号

### 3. 抢单并发测试
- 员工A和员工B同时打开抢单池
- 同时点击同一条线索的【领取】
- 只有一人成功，另一人提示"手慢了"

## 加密说明

- 使用AES加密存储手机号
- 硬编码密钥: `LOAN_SECRET_KEY_2023`
- 前端加密后存储，页面脱敏显示

## API函数（供外部工具调用）

```javascript
import { addLeadToCenter } from './utils/supabase'

// 添加线索
await addLeadToCenter(
  '13800138001',        // 手机号
  '张三',               // 姓名
  'plugin',             // 来源应用
  '百度搜索',            // 来源详情
  '信用贷'              // 意向类型
)
```

## 目录结构

```
loan-leads-system/
├── src/
│   ├── views/          # 页面组件
│   │   ├── Login.vue
│   │   ├── Staff.vue
│   │   ├── Boss.vue
│   │   └── Pool.vue
│   ├── utils/          # 工具函数
│   │   ├── supabase.js # Supabase客户端和API
│   │   └── crypto.js   # 加密工具
│   ├── App.vue
│   ├── main.js
│   ├── router.js
│   └── vant.js         # Vant UI组件注册
├── database.sql        # 数据库表结构
├── package.json
├── vite.config.js
└── README.md
```

## 注意事项

1. **生产环境务必修改加密密钥** (修改 `src/utils/crypto.js` 中的 `SECRET_KEY`)
2. **员工密码明文存储**（V1.0简化实现，生产环境建议加密）
3. **权限控制**通过前端路由实现，生产环境建议加后端验证

## 许可

MIT License
