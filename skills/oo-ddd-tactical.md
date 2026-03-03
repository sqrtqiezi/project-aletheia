---
name: oo-ddd-tactical
version: 1.0.0
author: project-aletheia
description: DDD 战术模式应用，基于 Eric Evans 的领域驱动设计
category: design
tags:
  - ddd
  - domain-modeling
  - tactical-patterns
  - aggregate
related_agent: oo-modeler
theory_base:
  - Domain-Driven Design (Evans)
---

# /oo-ddd-tactical

DDD 战术模式应用 skill，基于 Eric Evans 的领域驱动设计

## Usage
/oo-ddd-tactical [领域场景描述]

## Implementation
应用 DDD 战术模式进行领域建模

### 核心模式

#### 1. Entity (实体)
- 有唯一标识
- 有生命周期
- 可变的
- 标识的连续性

**识别方法**: 问"这是同一个东西吗？"如果答案取决于标识而非属性，就是实体。

#### 2. Value Object (值对象)
- 无标识
- 不可变
- 可替换
- 描述性的

**识别方法**: 问"两个对象属性相同，是否可互换？"如果是，就是值对象。

#### 3. Aggregate (聚合)
- 一致性边界
- 聚合根是唯一入口
- 内部对象通过根访问
- 事务边界

**设计规则**:
- 小聚合优先
- 聚合之间通过 ID 引用
- 一个事务只修改一个聚合
- 保护不变量

#### 4. Domain Service (领域服务)
- 无状态
- 表达领域操作
- 不属于任何实体或值对象
- 协调多个领域对象

**使用时机**:
- 操作涉及多个聚合
- 操作不自然属于任何单一对象
- 操作是领域概念

#### 5. Repository (仓储)
- 聚合的集合抽象
- 封装持久化细节
- 每个聚合根一个仓储

#### 6. Factory (工厂)
- 封装复杂创建逻辑
- 确保不变量
- 创建完整的聚合

### 输出格式

#### 聚合设计文档
```markdown
## 聚合: Order

### 聚合根
Order

### 内部实体
- OrderItem

### 值对象
- OrderId, Money, Quantity

### 不变量
1. 订单必须至少有一个订单项
2. 订单总额 = 所有订单项小计之和
3. 状态转换: Draft → Confirmed → Paid → Shipped

### 边界规则
- 外部只能通过 Order 访问 OrderItem
- Order 和 OrderItem 在同一事务中持久化

### 领域事件
- OrderPlaced, OrderConfirmed, OrderPaid
```

### 决策树

**实体 vs 值对象**:
```
有唯一标识?
  ├─ 是 → 标识是本质?
  │       ├─ 是 → Entity
  │       └─ 否 → 重新考虑
  └─ 否 → 属性相同可互换?
          ├─ 是 → Value Object
          └─ 否 → 重新考虑
```

**是否需要 Domain Service**:
```
行为是领域概念?
  ├─ 是 → 能放在某个实体中?
  │       ├─ 是 → 放在实体中
  │       └─ 否 → Domain Service
  └─ 否 → Application Service 或 Infrastructure Service
```
