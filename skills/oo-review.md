---
name: oo-review
description: Review object design across five dimensions (responsibility assignment, cohesion/coupling, domain model alignment, collaboration design, SOLID principles). Identify common issues and provide scoring. Use before finalizing design or during design reviews.
tools: Read
---

# /oo-review

对象设计评审 skill，综合检查设计质量

## Usage
/oo-review [设计文档路径或代码路径]

## Implementation
执行全面的对象设计评审

### 评审维度

#### 1. 职责分配
- [ ] 每个类的职责清晰且单一
- [ ] 职责分配遵循 GRASP 模式
- [ ] 没有上帝类 (职责过多)
- [ ] 没有贫血类 (只有数据没有行为)
- [ ] 职责与角色构造型匹配

#### 2. 内聚与耦合
- [ ] 类内职责高度相关 (高内聚)
- [ ] 类间依赖最小化 (低耦合)
- [ ] 使用接口降低耦合
- [ ] 依赖方向正确 (依赖抽象)
- [ ] 没有循环依赖

#### 3. 领域模型
- [ ] 使用统一语言命名
- [ ] 实体和值对象区分清晰
- [ ] 聚合边界合理
- [ ] 不变量得到保护
- [ ] 领域逻辑在领域层

#### 4. 协作设计
- [ ] 对象协作能完成所有场景
- [ ] 协作契约清晰 (前置/后置条件)
- [ ] 消息传递路径合理
- [ ] 协作者数量合理 (< 5)
- [ ] 没有长的消息链 (> 3 层)

#### 5. SOLID 原则
- [ ] 单一职责原则 (SRP)
- [ ] 开闭原则 (OCP)
- [ ] 里氏替换原则 (LSP)
- [ ] 接口隔离原则 (ISP)
- [ ] 依赖倒置原则 (DIP)

#### 6. 设计模式应用
- [ ] 模式使用恰当
- [ ] 没有过度设计
- [ ] 没有反模式

### 常见问题识别

#### 贫血模型
**症状**: 对象只有 getter/setter，所有逻辑在服务中
**建议**: 将行为移到对象中，遵循"Tell, Don't Ask"

#### 上帝类
**症状**: 一个类承担过多职责
**建议**: 应用单一职责原则，拆分类

#### 过度耦合
**症状**: 类依赖过多其他类
**建议**: 引入接口，使用依赖注入，考虑 Facade 模式

#### 聚合过大
**症状**: 聚合包含过多对象，事务过大
**建议**: 缩小聚合边界，考虑最终一致性

#### 循环依赖
**症状**: A 依赖 B，B 依赖 A
**建议**: 引入中介者，或使用依赖倒置

### 评分标准

每个维度 0-10 分:
- 9-10: 优秀
- 7-8: 良好
- 5-6: 及格
- 0-4: 需要改进

### 输出格式

```markdown
# 设计评审报告

## 总体评分: 8.2/10

## 各维度评分
- 职责分配: 9/10
- 内聚耦合: 8/10
- 领域模型: 8/10
- 协作设计: 7/10
- SOLID 原则: 9/10

## 发现的问题

### 高优先级
1. OrderService 存在贫血模型问题
   - 位置: src/services/OrderService.java
   - 建议: 将业务逻辑移到 Order 实体中

### 中优先级
2. Payment 聚合过大
   - 位置: src/domain/Payment.java
   - 建议: 考虑拆分为 Payment 和 PaymentMethod 两个聚合

### 低优先级
3. 部分类缺少接口
   - 建议: 为 Repository 和 Service 定义接口

## 优点
- 使用了统一语言
- 聚合边界清晰
- GRASP 模式应用得当

## 改进建议
1. 重构 OrderService，采用充血模型
2. 优化 Payment 聚合设计
3. 补充接口定义
```
