---
name: oo-crc
version: 1.0.0
author: project-aletheia
description: CRC 卡片建模，基于 Wirfs-Brock 的责任驱动设计
category: design
tags:
  - oo
  - crc
  - responsibility
  - collaboration
related_agent: oo-modeler
theory_base:
  - Object Design (Wirfs-Brock)
---

# /oo-crc

CRC 卡片建模 skill，基于 Wirfs-Brock 的责任驱动设计

## Usage
/oo-crc [用例或场景描述]

## Implementation
创建 CRC (Class-Responsibility-Collaborator) 卡片

### 步骤
1. **识别候选对象**: 从用例中提取名词
2. **分配职责**: 确定每个对象的 Doing 和 Knowing 职责
3. **识别协作者**: 确定完成职责需要的协作对象
4. **角色分类**: 使用角色构造型分类

### 角色构造型
- Information Holder: 持有并提供信息
- Service Provider: 执行工作和服务
- Coordinator: 协调其他对象活动
- Controller: 处理外部事件
- Structurer: 维护对象关系
- Interfacer: 转换信息或请求

### 输出格式
```
类名: OrderProcessor
角色: Coordinator

职责:
  Doing:
  - 协调订单处理流程
  - 验证订单完整性
  - 触发订单确认

  Knowing:
  - 订单处理规则
  - 处理步骤顺序

协作者:
  - Order (订单数据)
  - OrderValidator (验证服务)
  - PricingService (价格计算)
  - OrderRepository (持久化)
```

### 设计检查
- 职责是否单一且清晰
- 协作者数量是否合理 (建议 < 5)
- 是否符合角色构造型
- 职责分配是否遵循信息专家原则
