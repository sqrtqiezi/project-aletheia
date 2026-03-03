---
name: req-quality-check
description: Check requirements quality across six dimensions (unambiguous, complete, consistent, verifiable, traceable, prioritized) based on Wiegers and Robertson standards. Use before finalizing requirements documents.
tools: Read
---

# /req-quality-check

需求质量检查 skill，基于 Wiegers 和 Robertson 的质量标准

## Usage
/req-quality-check [需求文档路径]

## Implementation
执行需求质量检查，评估以下维度：

### 质量标准
1. **明确性 (Unambiguous)**: 需求是否有唯一解释
2. **完整性 (Complete)**: 是否覆盖所有场景
3. **一致性 (Consistent)**: 需求之间是否冲突
4. **可验证性 (Verifiable)**: 是否有明确的验收标准
5. **可追踪性 (Traceable)**: 是否可追踪到业务目标
6. **优先级 (Prioritized)**: 是否有明确的优先级

### 检查清单
- [ ] 每个需求都有唯一标识
- [ ] 使用领域统一语言
- [ ] 避免模糊词汇 (如"灵活"、"用户友好")
- [ ] 有明确的验收标准
- [ ] 边界场景已考虑
- [ ] 非功能需求已定义
- [ ] 需求之间无冲突
- [ ] 可追踪到用户故事或用例

### 输出
生成质量检查报告，包括：
- 质量评分 (每个维度)
- 发现的问题列表
- 改进建议
- 高风险需求标注
