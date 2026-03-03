---
name: oo-grasp
version: 1.0.0
author: project-aletheia
description: GRASP 模式应用，基于职责分配模式
category: design
tags:
  - oo
  - grasp
  - patterns
  - responsibility
related_agent: oo-modeler
theory_base:
  - Object Design (Wirfs-Brock)
  - Applying UML and Patterns (Larman)
---

# /oo-grasp

GRASP 模式应用 skill，基于 Wirfs-Brock 和 Larman 的职责分配模式

## Usage
/oo-grasp [场景描述]

## Implementation
应用 GRASP (General Responsibility Assignment Software Patterns) 进行职责分配

### 九大模式

#### 1. Information Expert (信息专家)
**原则**: 将职责分配给拥有完成该职责所需信息的类

**示例**: 计算订单总额 → Order (因为 Order 拥有 OrderItem 信息)

#### 2. Creator (创建者)
**原则**: 当满足以下条件时，由 A 创建 B:
- A 包含 B
- A 记录 B
- A 密切使用 B
- A 有 B 的初始化数据

**示例**: Order 创建 OrderItem

#### 3. Controller (控制器)
**原则**: 用控制器对象处理系统事件

**类型**:
- Facade Controller: 代表整个系统
- Use Case Controller: 代表一个用例场景

**示例**: OrderController 处理下单请求

#### 4. Low Coupling (低耦合)
**原则**: 分配职责时保持类之间的依赖最小化

**评估**: 计算类的依赖数量，越少越好

#### 5. High Cohesion (高内聚)
**原则**: 确保类的职责紧密相关，专注于单一目标

**评估**: 类的职责是否都围绕同一个主题

#### 6. Polymorphism (多态)
**原则**: 使用多态处理类型变化，避免条件逻辑

**示例**:
```java
// 避免
if (paymentType == "CreditCard") { ... }
else if (paymentType == "PayPal") { ... }

// 使用多态
interface PaymentMethod { void pay(); }
```

#### 7. Pure Fabrication (纯虚构)
**原则**: 创建不代表领域概念的类来支持高内聚低耦合

**示例**: DatabaseConnection, Logger (技术类，非领域类)

#### 8. Indirection (间接)
**原则**: 引入中介对象来降低耦合

**示例**: Adapter, Facade, Mediator 模式

#### 9. Protected Variations (受保护变化)
**原则**: 识别变化点并封装它们

**方法**: 使用接口、多态、配置文件等

### 应用流程

1. **识别职责**: 从场景中提取需要完成的职责
2. **选择模式**: 为每个职责选择合适的 GRASP 模式
3. **分配职责**: 将职责分配给类
4. **验证设计**: 检查内聚和耦合

### 输出格式

#### 职责分配矩阵
| 职责 | 候选类 | 选择理由 | GRASP 模式 |
|------|--------|----------|-----------|
| 计算订单总额 | Order | 拥有订单项信息 | Information Expert |
| 创建订单项 | Order | 包含订单项 | Creator |
| 处理下单请求 | OrderController | 系统事件处理 | Controller |
| 验证订单 | OrderValidator | 避免 Order 过于复杂 | Pure Fabrication |

### 设计检查

**内聚性检查**:
- 类的所有职责是否相关？
- 能否用一句话描述类的目的？
- 职责数量是否合理 (3-7 个)？

**耦合性检查**:
- 依赖的类数量 (建议 < 5)
- 是否依赖具体类而非接口？
- 是否有循环依赖？

### 常见问题

**Q: Information Expert 导致上帝类怎么办？**
A: 结合 Pure Fabrication，将部分职责提取到专门的类

**Q: 何时使用 Pure Fabrication？**
A: 当遵循 Information Expert 会导致低内聚或高耦合时

**Q: Controller 应该有多少职责？**
A: Controller 应该是"薄"的，只负责协调，不包含业务逻辑
