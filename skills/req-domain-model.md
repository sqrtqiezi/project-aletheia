---
name: req-domain-model
version: 1.0.0
author: project-aletheia
description: 领域概念建模，基于 DDD 的统一语言和概念模型
category: requirements
tags:
  - requirements
  - domain-modeling
  - ubiquitous-language
  - ddd
related_agent: requirements-analyst
related_skills:
  - oo-ddd-tactical
theory_base:
  - Domain-Driven Design (Evans)
---

# /req-domain-model

领域概念建模 skill，基于 DDD 的统一语言和概念模型

## Usage
/req-domain-model [业务领域描述]

## Implementation
构建领域概念模型和统一语言词汇表

### 领域建模步骤

#### 1. 识别核心概念

从需求和业务对话中提取名词，识别核心业务概念

**方法**:
- 分析需求文档中的名词
- 与领域专家对话
- 观察业务流程
- 查看现有系统

**示例**: 电商领域
```
- 商品 (Product)
- 订单 (Order)
- 购物车 (Cart)
- 客户 (Customer)
- 支付 (Payment)
- 配送 (Delivery)
```

#### 2. 定义概念关系

识别概念之间的关系

**关系类型**:
- 关联 (Association): A 与 B 相关
- 聚合 (Aggregation): A 包含 B
- 组合 (Composition): A 由 B 组成
- 泛化 (Generalization): A 是 B 的一种

**示例**:
```
- 订单 包含 订单项
- 订单 关联 客户
- 订单 关联 支付
- 客户 拥有 购物车
- 购物车 包含 购物车项
```

#### 3. 识别概念属性

为每个概念定义关键属性

**示例**: 订单
```
- 订单号 (唯一标识)
- 下单时间
- 订单状态 (草稿、已确认、已支付、已发货、已完成)
- 订单总额
- 收货地址
```

#### 4. 识别概念行为

识别概念的关键行为（动词）

**示例**: 订单
```
- 添加订单项
- 移除订单项
- 计算总额
- 确认订单
- 取消订单
- 支付
```

#### 5. 建立统一语言

与领域专家协商，确定每个概念的标准术语

### 统一语言词汇表模板

```markdown
# 统一语言词汇表: [领域名称]

## 核心概念

### [概念名称]

**定义**: [清晰的定义，1-2 句话]

**英文术语**: [English Term]

**别名**: [其他可能的叫法]

**属性**:
- [属性1]: [类型] - [说明]
- [属性2]: [类型] - [说明]

**行为**:
- [行为1]: [说明]
- [行为2]: [说明]

**业务规则**:
- [规则1]
- [规则2]

**关系**:
- 与 [概念A] 的关系: [关系类型和说明]
- 与 [概念B] 的关系: [关系类型和说明]

**生命周期**: [如果有明确的生命周期]
- 状态1 → 状态2 → 状态3

**示例**:
[具体的业务示例]

---

[重复上述结构定义其他概念]
```

### 完整示例

```markdown
# 统一语言词汇表: 电商订单域

## 核心概念

### 订单 (Order)

**定义**: 客户购买商品的交易记录，包含商品信息、价格、收货信息等。

**英文术语**: Order

**别名**: 交易单、购买订单

**属性**:
- 订单号 (OrderId): String - 唯一标识，格式 ORD-YYYYMMDD-XXXXX
- 下单时间 (OrderTime): DateTime - 订单创建的时间
- 订单状态 (Status): OrderStatus - 当前状态
- 订单总额 (TotalAmount): Money - 包含所有商品和运费的总金额
- 客户 (Customer): CustomerId - 下单的客户
- 收货地址 (ShippingAddress): Address - 配送地址
- 订单项 (Items): List<OrderItem> - 订单包含的商品列表

**行为**:
- 添加订单项 (addItem): 向订单中添加商品
- 移除订单项 (removeItem): 从订单中移除商品
- 计算总额 (calculateTotal): 计算订单总金额
- 确认订单 (confirm): 客户确认订单，进入待支付状态
- 取消订单 (cancel): 取消订单
- 标记已支付 (markAsPaid): 支付成功后更新状态

**业务规则**:
- 订单必须至少包含一个订单项
- 订单总额必须等于所有订单项小计之和加上运费
- 只有草稿状态的订单可以修改订单项
- 已支付的订单不能取消，只能申请退款
- 订单号在系统中必须唯一

**关系**:
- 与 客户 (Customer): 多对一，一个客户可以有多个订单
- 与 订单项 (OrderItem): 一对多，一个订单包含多个订单项
- 与 支付 (Payment): 一对一，一个订单对应一次支付
- 与 配送 (Delivery): 一对一，一个订单对应一次配送

**生命周期**:
```
草稿 (Draft)
  ↓ confirm()
已确认 (Confirmed)
  ↓ pay()
已支付 (Paid)
  ↓ ship()
已发货 (Shipped)
  ↓ deliver()
已完成 (Delivered)

任何状态 → cancel() → 已取消 (Cancelled)
已支付后 → refund() → 已退款 (Refunded)
```

**示例**:
```
订单号: ORD-20260303-00123
客户: 张三 (ID: CUST-001)
下单时间: 2026-03-03 14:30:00
状态: 已支付
订单项:
  - iPhone 15 Pro × 1 = ¥7999
  - AirPods Pro × 1 = ¥1999
运费: ¥0 (满额免运费)
总额: ¥9998
收货地址: 北京市朝阳区xxx路xxx号
```

---

### 订单项 (OrderItem)

**定义**: 订单中的单个商品条目，包含商品、数量和价格信息。

**英文术语**: Order Item, Line Item

**属性**:
- 商品 (Product): ProductId - 商品标识
- 数量 (Quantity): Integer - 购买数量
- 单价 (UnitPrice): Money - 商品单价
- 小计 (Subtotal): Money - 数量 × 单价

**行为**:
- 计算小计 (calculateSubtotal): 计算该订单项的金额

**业务规则**:
- 数量必须大于 0
- 单价在订单创建时锁定，不受后续商品价格变动影响
- 小计 = 数量 × 单价

**关系**:
- 与 订单 (Order): 多对一，属于某个订单
- 与 商品 (Product): 多对一，引用商品信息

---

### 客户 (Customer)

**定义**: 在平台上注册并可以下单购买商品的用户。

**英文术语**: Customer

**别名**: 买家、用户

**属性**:
- 客户号 (CustomerId): String - 唯一标识
- 姓名 (Name): String
- 手机号 (Phone): String
- 邮箱 (Email): String
- 会员等级 (MemberLevel): Enum - 普通、银卡、金卡、钻石
- 注册时间 (RegisterTime): DateTime

**行为**:
- 下单 (placeOrder): 创建新订单
- 查看订单历史 (viewOrderHistory): 查看历史订单
- 管理地址簿 (manageAddresses): 添加、编辑、删除收货地址

**业务规则**:
- 手机号和邮箱必须唯一
- 会员等级根据累计消费金额自动升级

**关系**:
- 与 订单 (Order): 一对多，可以有多个订单
- 与 地址 (Address): 一对多，可以有多个收货地址

---

## 限界上下文

### 订单上下文 (Order Context)
包含: Order, OrderItem, OrderStatus

### 客户上下文 (Customer Context)
包含: Customer, Address, MemberLevel

### 商品上下文 (Product Context)
包含: Product, Category, Inventory

### 支付上下文 (Payment Context)
包含: Payment, PaymentMethod, Transaction

### 配送上下文 (Delivery Context)
包含: Delivery, Carrier, TrackingInfo

## 上下文映射

- 订单上下文 → 客户上下文: 通过 CustomerId 引用
- 订单上下文 → 商品上下文: 通过 ProductId 引用
- 订单上下文 → 支付上下文: 通过 OrderId 关联
- 订单上下文 → 配送上下文: 通过 OrderId 关联
```

### 概念模型图

使用简单的文本图表达概念关系：

```
┌─────────────┐
│   Customer  │
│  (客户)      │
└──────┬──────┘
       │ 1
       │ places
       │
       │ *
┌──────▼──────┐      ┌─────────────┐
│    Order    │ 1  * │  OrderItem  │
│   (订单)     ├──────┤  (订单项)    │
└──────┬──────┘      └──────┬──────┘
       │                    │
       │ 1                  │ *
       │                    │ references
       │                    │
       │ 1                  │ 1
┌──────▼──────┐      ┌──────▼──────┐
│   Payment   │      │   Product   │
│   (支付)     │      │   (商品)     │
└─────────────┘      └─────────────┘
```

### 质量检查

- [ ] 所有核心概念都有清晰定义
- [ ] 使用业务语言，避免技术术语
- [ ] 概念之间的关系明确
- [ ] 关键业务规则已记录
- [ ] 与领域专家达成共识
- [ ] 术语在团队中统一使用
- [ ] 有具体的业务示例

### 输出
生成领域概念模型文档，包括：
- 统一语言词汇表
- 概念定义和属性
- 概念关系图
- 业务规则
- 限界上下文划分
- 上下文映射
