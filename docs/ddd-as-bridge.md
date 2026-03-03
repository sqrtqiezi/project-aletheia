# DDD 作为需求分析与对象建模的桥梁

## 概述

Domain-Driven Design (DDD) 在本项目的两个 agent 中扮演着关键的"桥梁"角色，连接需求分析和对象建模两个阶段，确保从业务需求到技术实现的无缝转换。

---

## DDD 的双重角色

### 在 requirements-analyst 中的角色

**位置**: 五层认知架构的第 5 层（语义层）

**职责**: 统一语言与领域概念模型
- 建立业务与技术的共同语言
- 识别核心领域概念及其关系
- 为对象设计提供语义基础

**关键输出**:
1. **统一语言词汇表 (Ubiquitous Language)**
   - 业务术语的标准定义
   - 避免歧义和误解
   - 团队共同使用的语言

2. **领域概念模型 (Conceptual Model)**
   - 核心业务概念
   - 概念之间的关系
   - 概念的属性和行为（概念层面）

**示例**:
```
概念: 订单 (Order)
定义: 客户购买商品的交易记录
属性: 订单号、下单时间、订单状态、订单总额
关系: 订单 包含 订单项，订单 属于 客户
行为: 添加订单项、计算总额、确认订单
```

---

### 在 oo-modeler 中的角色

**位置**: 四层认知架构的第 3 层（语义桥梁）

**职责**: 从概念模型到设计模型
- 接收统一语言和概念模型
- 应用 DDD 战术模式转化为设计
- 确保代码与业务语言的一致性

**关键输入**:
- requirements-analyst 的统一语言词汇表
- requirements-analyst 的领域概念模型

**转化过程**:
1. **概念 → 对象分类**
   - 有唯一标识的概念 → Entity
   - 描述性的概念 → Value Object
   - 一致性边界 → Aggregate

2. **关系 → 对象关系**
   - 包含关系 → 组合/聚合
   - 关联关系 → 引用
   - 泛化关系 → 继承/接口

3. **行为 → 方法**
   - 概念的行为 → 对象的方法
   - 使用统一语言命名

**示例**:
```java
// 从概念模型转化为设计模型
public class Order {  // Entity（有唯一标识）
    private final OrderId id;  // 唯一标识
    private OrderStatus status;  // 状态
    private List<OrderItem> items;  // 聚合内部对象

    // 行为使用统一语言命名
    public void addItem(Product product, int quantity) { }
    public Money calculateTotal() { }
    public void confirm() { }
}
```

---

## DDD 桥梁的工作流程

### 完整流程图

```
┌─────────────────────────────────────────────────────────────┐
│                    需求分析阶段                              │
│                (requirements-analyst)                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. 问题探索 (哲学层)                                        │
│     ↓                                                        │
│  2. 需求发现 (质量层)                                        │
│     ↓                                                        │
│  3. 用例建模 (结构层)                                        │
│     ↓                                                        │
│  4. 需求实例化 (精度层)                                      │
│     ↓                                                        │
│  5. 领域建模 (语义层) ← DDD 概念层                          │
│     - 建立统一语言                                           │
│     - 识别领域概念                                           │
│     - 定义概念关系                                           │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ DDD 桥梁传递
                       │ • 统一语言词汇表
                       │ • 领域概念模型
                       │ • 业务规则
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    对象建模阶段                              │
│                   (oo-modeler)                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. 对象识别 (责任驱动核心)                                  │
│     - 使用统一语言命名对象                                   │
│     ↓                                                        │
│  2. 场景分析 (交互与场景建模)                                │
│     - 从用例识别对象交互                                     │
│     ↓                                                        │
│  3. 领域建模 (语义桥梁) ← DDD 设计层                        │
│     - 概念 → Entity/Value Object                            │
│     - 关系 → Aggregate                                       │
│     - 行为 → 方法                                            │
│     ↓                                                        │
│  4. UML 建模 (形式表达)                                      │
│     - 类图、序列图                                           │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
                   代码实现
```

---

## DDD 桥梁的关键价值

### 1. 语言一致性

**问题**: 传统方法中，业务人员和技术人员使用不同的语言
- 业务: "订单"、"下单"、"确认"
- 技术: "OrderEntity"、"createOrder()"、"setStatus()"

**DDD 解决方案**: 统一语言
- 代码中的类名、方法名直接使用业务术语
- 消除"翻译"过程中的信息损耗

**示例**:
```java
// ❌ 传统方式
public class OrderEntity {
    public void setStatus(int status) { }
}

// ✅ DDD 方式（使用统一语言）
public class Order {
    public void confirm() { }  // 业务术语
    public void cancel() { }   // 业务术语
}
```

---

### 2. 概念映射

**问题**: 需求中的概念如何转化为代码中的对象？

**DDD 解决方案**: 明确的映射规则

| 需求阶段（概念模型） | 设计阶段（对象模型） | 判断标准 |
|---------------------|---------------------|---------|
| 有唯一标识的概念 | Entity | 标识是本质 |
| 描述性的概念 | Value Object | 属性值定义对象 |
| 一致性边界 | Aggregate | 必须同时修改的对象组 |
| 跨概念的操作 | Domain Service | 不属于任何单一概念 |

**示例**:
```
需求: "订单包含多个订单项，订单总额必须等于所有订单项之和"

分析:
- "订单" 有唯一订单号 → Entity
- "订单项" 依附于订单 → Entity（聚合内部）
- "订单总额" 是计算值 → Value Object (Money)
- "订单+订单项" 必须保持一致 → Aggregate

设计:
public class Order {  // Aggregate Root
    private List<OrderItem> items;  // 内部 Entity

    public Money calculateTotal() {  // 保护不变量
        return items.stream()
            .map(OrderItem::subtotal)
            .reduce(Money.ZERO, Money::add);
    }
}
```

---

### 3. 业务规则保护

**问题**: 业务规则在哪里实现？如何确保不被违反？

**DDD 解决方案**: 在聚合中保护不变量

**需求阶段识别的业务规则**:
```
1. 订单必须至少有一个订单项
2. 订单总额 = 所有订单项小计之和
3. 只有草稿状态的订单可以修改
```

**设计阶段的实现**:
```java
public class Order {  // Aggregate Root
    private List<OrderItem> items;
    private OrderStatus status;

    // 规则 1: 订单必须至少有一个订单项
    public void confirm() {
        if (items.isEmpty()) {
            throw new IllegalStateException(
                "Cannot confirm empty order");
        }
        this.status = OrderStatus.CONFIRMED;
    }

    // 规则 3: 只有草稿状态可以修改
    public void addItem(Product product, int quantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(
                "Cannot modify non-draft order");
        }
        items.add(new OrderItem(product, quantity));
    }

    // 规则 2: 总额计算
    public Money calculateTotal() {
        return items.stream()
            .map(OrderItem::subtotal)
            .reduce(Money.ZERO, Money::add);
    }
}
```

---

### 4. 上下文边界

**问题**: 大型系统中，同一个术语在不同场景下可能有不同含义

**DDD 解决方案**: 限界上下文 (Bounded Context)

**需求阶段识别上下文**:
```
"客户" 在不同上下文中的含义：
- 销售上下文: 购买者，关注购买历史和偏好
- 支持上下文: 服务对象，关注问题和工单
- 财务上下文: 付款方，关注账单和支付
```

**设计阶段的体现**:
```java
// 销售上下文
package com.example.sales;
public class Customer {
    private CustomerId id;
    private List<Order> orderHistory;
    private CustomerPreference preference;
}

// 支持上下文
package com.example.support;
public class Customer {
    private CustomerId id;
    private List<Ticket> tickets;
    private SupportLevel level;
}

// 通过 CustomerId 关联，但模型不同
```

---

## 实践指南

### 需求阶段的 DDD 实践

使用 `/req-domain-model` skill:

1. **识别核心概念**
   ```
   从需求文档中提取名词
   → 订单、客户、商品、支付、配送
   ```

2. **建立统一语言**
   ```
   与业务专家确认术语
   - "订单" 还是 "交易单"？
   - "确认订单" 还是 "提交订单"？
   ```

3. **定义概念模型**
   ```
   订单 (Order)
   - 属性: 订单号、状态、总额
   - 行为: 添加订单项、确认、取消
   - 关系: 包含订单项、属于客户
   ```

4. **识别业务规则**
   ```
   - 订单必须至少有一个订单项
   - 订单总额 = 订单项小计之和
   ```

---

### 设计阶段的 DDD 实践

使用 `/oo-ddd-tactical` skill:

1. **概念分类**
   ```
   订单 → Entity (有唯一订单号)
   订单项 → Entity (聚合内部)
   金额 → Value Object (不可变)
   地址 → Value Object (描述性)
   ```

2. **聚合设计**
   ```
   Aggregate: Order
   - Root: Order
   - Internal: OrderItem
   - Boundary: 订单和订单项必须一致
   ```

3. **方法命名**
   ```
   使用统一语言:
   - confirm() 而非 setStatusToConfirmed()
   - cancel() 而非 setStatusToCancelled()
   - addItem() 而非 addOrderItem()
   ```

4. **不变量保护**
   ```java
   public void confirm() {
       // 检查不变量
       if (items.isEmpty()) {
           throw new IllegalStateException(...);
       }
       // 状态转换
       this.status = OrderStatus.CONFIRMED;
   }
   ```

---

## 协作示例

### 场景: 电商订单功能

#### 第 1 步: 需求分析 (requirements-analyst)

```bash
Task(subagent_type="requirements-analyst",
     prompt="分析电商订单功能的需求")
```

**输出**:
- 用例: "客户下单"
- 用户故事: "作为购买者，我想要创建订单..."
- **统一语言词汇表**:
  ```
  订单 (Order): 客户购买商品的交易记录
  订单项 (OrderItem): 订单中的单个商品条目
  确认订单 (confirm): 客户确认订单内容，进入待支付状态
  ```
- **领域概念模型**:
  ```
  订单 包含 订单项
  订单 属于 客户
  订单 关联 支付
  ```

#### 第 2 步: 对象建模 (oo-modeler)

```bash
Task(subagent_type="oo-modeler",
     prompt="基于需求分析的统一语言和概念模型，设计订单对象模型")
```

**输入** (来自 requirements-analyst):
- 统一语言词汇表
- 领域概念模型
- 业务规则

**处理** (应用 DDD 战术模式):
```bash
/oo-ddd-tactical "订单领域"
```

**输出**:
```java
// 使用统一语言命名
public class Order {  // Entity
    private final OrderId id;
    private List<OrderItem> items;  // Aggregate
    private OrderStatus status;

    // 使用统一语言命名方法
    public void confirm() {
        // 保护业务规则
        if (items.isEmpty()) {
            throw new IllegalStateException(
                "Cannot confirm empty order");
        }
        this.status = OrderStatus.CONFIRMED;
    }

    public void addItem(Product product, int quantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(
                "Cannot modify non-draft order");
        }
        items.add(new OrderItem(product, quantity));
    }
}
```

---

## 检查清单

### 需求阶段 (requirements-analyst)

- [ ] 建立了统一语言词汇表
- [ ] 识别了核心领域概念
- [ ] 定义了概念之间的关系
- [ ] 记录了关键业务规则
- [ ] 与领域专家达成共识
- [ ] 使用业务语言而非技术术语

### 设计阶段 (oo-modeler)

- [ ] 对象命名使用统一语言
- [ ] 概念正确映射为 Entity/Value Object
- [ ] 聚合边界合理
- [ ] 业务规则在聚合中得到保护
- [ ] 方法命名使用业务术语
- [ ] 代码可以被业务人员理解

### 桥梁检查

- [ ] 需求文档中的术语在代码中一致使用
- [ ] 概念模型清晰映射为对象模型
- [ ] 业务规则在代码中得到实现
- [ ] 没有"翻译"损耗
- [ ] 业务人员和技术人员使用相同语言

---

## 总结

DDD 在本项目中的桥梁作用体现在：

1. **语言桥梁**: 统一语言确保需求和设计使用相同术语
2. **概念桥梁**: 概念模型直接映射为对象模型
3. **规则桥梁**: 业务规则从需求传递到设计实现
4. **上下文桥梁**: 限界上下文在需求和设计中保持一致

通过 DDD 这座桥梁，我们实现了：
- 需求分析和对象建模的无缝衔接
- 业务语言和技术实现的统一
- 从问题空间到解决方案空间的平滑过渡

**关键原则**:
> DDD 不是需求分析的方法，也不是对象设计的方法，而是连接两者的桥梁。它确保我们在需求阶段建立的业务理解，能够完整、准确地传递到设计和实现阶段。

---

**文档版本**: 1.0.0
**创建日期**: 2026-03-03
**作者**: project-aletheia
