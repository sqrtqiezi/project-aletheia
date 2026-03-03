---
name: oo-gate-check
description: Evaluate design quality using three gates (responsibility clarity 0-5 scoring, coupling control with circular dependency detection, domain alignment check). Detect five anti-patterns (God Object, Anemic Model, Circular Dependency, Inappropriate Intimacy, Feature Envy). Use after design drafting to ensure quality standards.
tools: Read
---

# /oo-gate-check

对象设计门控检查 skill，评估设计是否满足质量标准

## Usage
/oo-gate-check [设计文档路径或内容]

## Implementation
执行三个关键门控检查，确保设计质量

---

## Gate 1: Responsibility Clarity Gate

### 目的
评估对象职责的清晰度和单一性

### 评分标准 (0-5 分)

**0 分 - 只有数据结构**
- 只定义了属性，无职责
- 示例: "User 有 name, email, password"

**1 分 - 职责不清晰**
- 有对象但职责陈述模糊
- 示例: "UserManager 管理用户"

**2 分 - 职责分散或集中**
- 职责过于分散（碎片化）
- 或职责过于集中（上帝对象）
- 示例: "UserService 有 15 个职责"

**3 分 - 职责清晰** ✅ **通过门槛**
- 每个对象有明确的职责陈述
- 符合单一职责原则
- 示例: "UserAuthenticator 负责验证用户凭证"

**4 分 - 职责清晰 + 协作简单**
- 职责清晰
- 协作关系简单明了
- 角色构造型明确

**5 分 - 完美职责分配**
- 职责清晰
- 协作简单
- 符合 GRASP 模式

### 检查清单

#### 职责清晰性
- [ ] 每个对象有明确的职责陈述
- [ ] 职责陈述使用动词（Doing）或名词（Knowing）
- [ ] 职责陈述具体，非模糊

#### 单一职责原则（SRP）
- [ ] 每个对象的职责数 ≤ 5
- [ ] 职责之间有内聚性
- [ ] 对象有单一的变化原因

#### 上帝对象检测
- [ ] 无对象的职责 > 5 个
- [ ] 无对象被 > 10 个其他对象依赖
- [ ] 无对象的方法 > 20 个

#### 懒惰对象检测
- [ ] 无对象只有 getter/setter
- [ ] 每个对象至少有 1 个 Doing 职责
- [ ] 对象封装了行为，非仅数据容器

#### 职责分类
- [ ] 职责分为 Doing 和 Knowing
- [ ] Doing 职责有明确的动作
- [ ] Knowing 职责有明确的信息

### 检查方法

#### 1. 职责计数
```
for each object:
    count responsibilities
    if count > 5:
        flag as "God Object"
    if count == 0:
        flag as "Data Structure Only"
    if count == 1 and only getters/setters:
        flag as "Lazy Object"
```

#### 2. 职责清晰度评估
```
for each responsibility:
    check if statement is specific
    check if statement uses action verbs
    check if statement is measurable
```

#### 3. 内聚性检查
```
for each object:
    check if responsibilities are related
    check if responsibilities serve a common purpose
```

### 输出格式

```markdown
## Responsibility Clarity Gate 评估

**评分**: X/5

**评分理由**:
- [具体原因]

### 发现的问题

#### 上帝对象
1. **对象**: UserService
   - 职责数: 12
   - 建议: 拆分为 UserAuthenticator, UserProfileManager, UserNotifier

#### 懒惰对象
1. **对象**: UserDTO
   - 问题: 只有 getter/setter
   - 建议: 移除或转为 Value Object

#### 职责不清晰
1. **对象**: OrderProcessor
   - 职责: "处理订单"（过于模糊）
   - 建议: 明确为 "验证订单有效性"、"计算订单总价"、"创建订单记录"

### 统计
- 总对象数: X
- 职责清晰对象: Y
- 需要改进: Z

**决策**: ✅ 通过 / ❌ 不通过（需改进 Z 个对象）
```

---

## Gate 2: Coupling Control Gate

### 目的
评估对象之间的耦合度，确保低耦合高内聚

### 评分标准 (0-5 分)

**0 分 - 循环依赖**
- 存在 A → B → A
- 或 A → B → C → A

**1 分 - 过度耦合**
- 对象依赖 > 5 个其他对象
- 或被 > 10 个对象依赖

**2 分 - 紧耦合**
- 有紧耦合但无循环依赖
- 双向关联过多

**3 分 - 耦合可接受** ✅ **通过门槛**
- 每个对象的依赖数 ≤ 5
- 无循环依赖
- 依赖方向清晰

**4 分 - 低耦合**
- 耦合度低
- 高内聚
- 使用接口解耦

**5 分 - 完美解耦**
- 低耦合
- 高内聚
- 符合依赖倒置原则

### 禁止模式

#### 1. 循环依赖
```
❌ Order → OrderItem → Order
❌ User → Profile → User
❌ A → B → C → A
```

**检测方法**: 依赖图遍历，检测环

**补救措施**:
- 引入接口打破循环
- 使用事件解耦
- 引入中介者

---

#### 2. 上帝对象（依赖视角）
```
❌ UserService 被 15 个对象依赖
```

**检测方法**: 计算入度（被依赖次数）

**补救措施**:
- 拆分为多个专注的对象
- 提取接口

---

#### 3. 过度耦合
```
❌ OrderProcessor 依赖 8 个其他对象
```

**检测方法**: 计算出度（依赖次数）

**补救措施**:
- 减少依赖
- 使用 Facade 模式
- 应用依赖倒置

---

#### 4. 双向关联
```
❌ Order ↔ Customer (双向)
✅ Order → Customer (单向)
```

**检测方法**: 检查关联方向

**补救措施**:
- 改为单向关联
- 使用 ID 引用而非对象引用

---

### 检查清单

#### 循环依赖检测
- [ ] 无 A → B → A
- [ ] 无 A → B → C → A
- [ ] 依赖图是有向无环图（DAG）

#### 耦合度检测
- [ ] 每个对象的依赖数（出度）≤ 5
- [ ] 每个对象的被依赖数（入度）≤ 10
- [ ] 平均依赖数 ≤ 3

#### 依赖方向
- [ ] 依赖方向清晰（从高层到低层）
- [ ] 无双向关联（除非必要）
- [ ] 使用接口解耦（依赖倒置）

#### 内聚性
- [ ] 对象内部职责相关
- [ ] 对象有明确的边界
- [ ] 对象封装了完整的行为

### 检查方法

#### 1. 构建依赖图
```
for each object:
    list dependencies (outgoing edges)
    list dependents (incoming edges)
```

#### 2. 检测循环依赖
```
perform DFS on dependency graph
if back edge found:
    report circular dependency
```

#### 3. 计算耦合度
```
for each object:
    outgoing_degree = count(dependencies)
    incoming_degree = count(dependents)
    if outgoing_degree > 5:
        flag as "Over-coupled"
    if incoming_degree > 10:
        flag as "God Object"
```

### 输出格式

```markdown
## Coupling Control Gate 评估

**评分**: X/5

**评分理由**:
- [具体原因]

### 发现的问题

#### 循环依赖
1. **循环**: Order → OrderItem → Order
   - 建议: Order → OrderItem（单向），OrderItem 使用 orderId 引用

#### 过度耦合
1. **对象**: OrderProcessor
   - 依赖数: 8
   - 依赖: [列出依赖对象]
   - 建议: 使用 Facade 模式或减少依赖

#### 上帝对象（依赖视角）
1. **对象**: UserService
   - 被依赖数: 15
   - 建议: 拆分为 UserAuthService, UserProfileService

#### 双向关联
1. **关联**: Order ↔ Customer
   - 建议: 改为 Order → Customer（单向）

### 依赖图统计
- 总对象数: X
- 平均依赖数: Y
- 最大依赖数: Z
- 循环依赖数: N

**决策**: ✅ 通过 / ❌ 不通过（需修复 N 个问题）
```

---

## Gate 3: Domain Alignment Gate

### 目的
评估设计是否与领域概念一致

### 评分标准 (0-5 分)

**0 分 - 技术术语**
- 对象命名使用技术术语
- 示例: "DataAccessObject", "ServiceImpl"

**1 分 - 部分领域语言**
- 部分使用领域语言
- 但不一致

**2 分 - 领域语言但映射不清**
- 使用领域语言
- 但概念映射不清晰

**3 分 - 领域对齐** ✅ **通过门槛**
- 对象命名与领域概念一致
- 使用统一语言词汇表

**4 分 - 领域对齐 + 正确分类**
- 对象命名一致
- Entity/Value Object 分类正确

**5 分 - 完美对齐**
- 完全对齐
- 聚合边界清晰
- 领域服务合理

### 检查清单

#### 统一语言对齐
- [ ] 对象命名使用统一语言词汇表
- [ ] 方法命名使用领域术语
- [ ] 无技术术语（Manager, Service, Handler, Processor）
- [ ] 命名与需求文档一致

#### Entity/Value Object 分类
- [ ] Entity 有明确的标识符
- [ ] Entity 有生命周期
- [ ] Value Object 无标识符
- [ ] Value Object 不可变
- [ ] 分类理由清晰

#### 聚合设计
- [ ] 聚合边界清晰
- [ ] 聚合根明确
- [ ] 聚合内保持一致性
- [ ] 聚合间通过 ID 引用
- [ ] 聚合大小合理（≤ 5 个对象）

#### 领域服务
- [ ] 领域服务无状态
- [ ] 领域服务表达领域操作
- [ ] 领域服务不是"万能服务"
- [ ] 领域服务职责清晰

#### Repository
- [ ] 只为聚合根创建 Repository
- [ ] Repository 接口在领域层
- [ ] Repository 方法表达领域意图

### 检查方法

#### 1. 统一语言对齐检查
```
load ubiquitous_language_glossary
for each object:
    check if name in glossary
    if not:
        flag as "Not in Ubiquitous Language"
```

#### 2. Entity/Value Object 分类检查
```
for each object:
    if has identifier:
        should be Entity
    if immutable and no identifier:
        should be Value Object
    check if classification is correct
```

#### 3. 聚合边界检查
```
for each aggregate:
    check if aggregate root is clear
    check if size <= 5 objects
    check if invariants are maintained
    check if references are by ID
```

#### 4. 技术术语检测
```
technical_terms = ["Manager", "Service", "Handler", "Processor",
                   "Helper", "Util", "DAO", "DTO", "VO"]
for each object:
    if name contains technical_term:
        flag as "Technical Term"
```

### 输出格式

```markdown
## Domain Alignment Gate 评估

**评分**: X/5

**评分理由**:
- [具体原因]

### 发现的问题

#### 技术术语
1. **对象**: UserManager
   - 问题: 使用技术术语 "Manager"
   - 统一语言: [查找词汇表]
   - 建议: 改为 "UserAuthenticator" 或 "UserRegistrar"

#### Entity/Value Object 分类错误
1. **对象**: Address
   - 当前分类: Entity
   - 问题: 无标识符，应为 Value Object
   - 建议: 改为 Value Object，添加不可变约束

#### 聚合边界不清
1. **聚合**: Order
   - 问题: 聚合包含 10 个对象，过大
   - 建议: 拆分为 Order 和 Shipment 两个聚合

#### 领域服务问题
1. **服务**: OrderService
   - 问题: 职责过多，成为"万能服务"
   - 建议: 拆分为 OrderPricingService, OrderValidationService

#### Repository 问题
1. **Repository**: OrderItemRepository
   - 问题: 为非聚合根创建 Repository
   - 建议: 移除，通过 OrderRepository 访问

### 统一语言对齐统计
- 总对象数: X
- 使用统一语言: Y
- 使用技术术语: Z
- 对齐率: Y/X

**决策**: ✅ 通过 / ❌ 不通过（需改进 Z 个对象）
```

---

## Design Anti-Patterns Detection (设计反模式检测)

### 1. God Object (上帝对象)

**检测规则**:
```
if object.responsibilities > 5:
    flag as "God Object"
if object.methods > 20:
    flag as "God Object"
if object.dependents > 10:
    flag as "God Object"
```

**输出**:
```markdown
### 反模式: God Object

**对象**: UserService
- 职责数: 12
- 方法数: 25
- 被依赖数: 15

**影响**: 难以维护、测试、理解

**补救措施**:
1. 按职责拆分为多个对象
2. 应用单一职责原则
3. 使用 Facade 模式简化接口
```

---

### 2. Anemic Domain Model (贫血模型)

**检测规则**:
```
if object.only_has_getters_setters():
    flag as "Anemic Domain Model"
if object.doing_responsibilities == 0:
    flag as "Anemic Domain Model"
```

**输出**:
```markdown
### 反模式: Anemic Domain Model

**对象**: Order
- 问题: 只有 getter/setter，无业务逻辑
- 业务逻辑位置: OrderService（外部）

**影响**: 违反 OO 封装原则，逻辑分散

**补救措施**:
1. 将业务逻辑移入 Order 对象
2. 创建充血模型
3. 示例: Order.calculateTotal(), Order.validate()
```

---

### 3. Circular Dependency (循环依赖)

**检测规则**:
```
perform DFS on dependency graph
if back_edge_found:
    flag as "Circular Dependency"
```

**输出**:
```markdown
### 反模式: Circular Dependency

**循环**: Order → OrderItem → Order

**影响**: 难以理解、测试、重构

**补救措施**:
1. 改为单向: Order → OrderItem
2. OrderItem 使用 orderId (String) 引用
3. 或使用事件解耦
```

---

### 4. Inappropriate Intimacy (过度亲密)

**检测规则**:
```
if object_A.accesses(object_B.internal_state):
    flag as "Inappropriate Intimacy"
if bidirectional_association(A, B):
    flag as "Inappropriate Intimacy"
```

**输出**:
```markdown
### 反模式: Inappropriate Intimacy

**对象对**: Order ↔ Customer

**问题**: 双向关联，过度亲密

**影响**: 高耦合，难以独立变化

**补救措施**:
1. 改为单向: Order → Customer
2. Customer 通过查询获取 Orders
3. 或使用事件通知
```

---

### 5. Feature Envy (特性依恋)

**检测规则**:
```
if method.uses_more_data_from(other_object):
    flag as "Feature Envy"
```

**输出**:
```markdown
### 反模式: Feature Envy

**方法**: OrderService.calculateShippingCost()
- 问题: 大量使用 Order 的数据
- 建议: 移到 Order.calculateShippingCost()

**影响**: 职责分配错误，低内聚

**补救措施**:
1. 将方法移到数据所在的对象
2. 遵循 Information Expert 模式
```

---

## 综合评估报告

### 输出格式

```markdown
# 对象设计门控检查报告

## 执行摘要
- 检查时间: [时间戳]
- 检查范围: [文档/模块]
- 总体状态: ✅ 全部通过 / ⚠️ 部分通过 / ❌ 未通过

---

## Gate 1: Responsibility Clarity Gate
**评分**: X/5
**状态**: ✅ 通过 / ❌ 不通过

[详细评估]

---

## Gate 2: Coupling Control Gate
**评分**: Y/5
**状态**: ✅ 通过 / ❌ 不通过

[详细评估]

---

## Gate 3: Domain Alignment Gate
**评分**: Z/5
**状态**: ✅ 通过 / ❌ 不通过

[详细评估]

---

## 设计反模式检测

### 发现的反模式
1. **God Object**: 2 个
2. **Anemic Domain Model**: 3 个
3. **Circular Dependency**: 1 个
4. **Inappropriate Intimacy**: 2 个
5. **Feature Envy**: 1 个

[详细列表]

---

## 行动建议

### 高优先级（必须修复）
1. [建议 1]
2. [建议 2]

### 中优先级（应该改进）
1. [建议 1]
2. [建议 2]

### 低优先级（可以优化）
1. [建议 1]
2. [建议 2]

---

## 质量指标

- **职责清晰度**: X/Y (X%)
- **耦合度**: 平均 Z 个依赖
- **领域对齐率**: W/Y (W%)
- **反模式数**: N

---

## 下一步

- [ ] 修复高优先级问题
- [ ] 重新评估门控
- [ ] 继续实现阶段
```

---

## 使用场景

### 场景 1: 初步设计评估
```bash
# 在完成 CRC 卡片后
/oo-gate-check design-crc.md

# 检查职责分配是否合理
# 决定是否可以进入交互设计阶段
```

### 场景 2: 聚合设计审查
```bash
# 在完成聚合设计后
/oo-gate-check aggregate-design.md

# 检查聚合边界和领域对齐
# 识别设计反模式
```

### 场景 3: 发布前检查
```bash
# 在交付设计文档前
/oo-gate-check complete-design.md

# 全面检查三个门控
# 确保设计质量达标
```

---

## 集成到工作流

### 推荐工作流

```
1. 从用例识别对象
   ↓
2. 创建 CRC 卡片
   ↓
3. /oo-gate-check → Gate 1 评估
   ↓ (如果 < 3 分)
4. 重新分配职责
   ↓
5. 设计对象交互
   ↓
6. /oo-gate-check → Gate 2 评估
   ↓ (如果有循环依赖)
7. 重构依赖关系
   ↓
8. 应用 DDD 战术模式
   ↓
9. /oo-gate-check → Gate 3 评估
   ↓ (如果领域不对齐)
10. 调整对象命名和分类
    ↓
11. 最终门控检查
    ↓
12. 交付设计文档
```

---

## 自动化建议

### 可以自动化的检查
- 职责计数
- 依赖图构建和循环检测
- 技术术语扫描
- 耦合度计算

### 需要人工判断的检查
- 职责清晰度评估（需要理解业务）
- Entity/Value Object 分类（需要领域知识）
- 聚合边界合理性（需要业务理解）

---

## 质量指标

### 好的设计应该
- Responsibility Clarity Score ≥ 4
- Coupling Score ≥ 4
- Domain Alignment Score ≥ 4
- Anti-patterns Count = 0

### 警告信号
- Responsibility Clarity Score < 3
- 存在循环依赖
- Domain Alignment Score < 3
- Anti-patterns Count > 3
